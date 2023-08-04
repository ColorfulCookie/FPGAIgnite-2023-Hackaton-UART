library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

--TODO:
-- - resets everywhere
-- - parity bit in rx => what to dowith it?
-- - rx finished signal
entity uart is
    port (
        clk                      : in std_logic                     := '1';             --clock
        rst                      : in std_logic                     := '0';             --reset is high active
        tx_data_out              : out std_logic                    := '1';             --transmission bit output (Tx) (continuous 1 for 'off')
        tx_ready                 : out std_logic                    := '0';             -- port for signaling begin ready to transmit a new data word
        tx_data_word             : in std_logic_vector(7 downto 0) := (others => '1'); --transmission word (Tx) (continuous 1 for 'off')
        tx_start                 : in std_logic                     := '0';
        rx_data                  : in std_logic                     := '1';                                  --receiving bit (Rx) (continuous 1 for 'off')
        rx_finished_out          : out std_logic                    := '0';                                  -- port for signaling having finished receiving a data word
        cfg_parity_setting       : in std_logic_vector(1 downto 0)  := "00";                                 -- 00 -> parity off, 01-> parity even, 10-> parity odd
        cfg_clkSpeed_over_bdRate : in std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(87, 32)) -- sets the effective baudrate; clk/bd, e.g. for a 10MHz clk and with 115.2k Bd: 10 000 000 / 115 200 = 86.8
        -- bits_per_word: integer := 8;--nr of data bits in each transmission; hardcoded to 8 
    );
end entity uart;

architecture behav of uart is
    component uart_clock is
        port (
            I_clk            : in std_logic;
            I_reset          : in std_logic;
            I_sampling_delay : in std_logic_vector(31 downto 0);
            O_clk            : out std_logic
        );
    end component;
    --constant design variables
    constant bits_per_word    : integer range 0 to 8          := 8;
    constant bits_per_package : integer range 0 to 15         := bits_per_word + 2; --number of bits in each package: bits per message + starting bit + ending bit + parity bit - starting to count at zero
    --design variables
    signal sampling_delay     : std_logic_vector(31 downto 0) := (others => '0');
    --rx signals
    type state_type_rx is (rx_idle, rx_starting, rx_receiving, rx_finished);
    signal rx_state       : state_type_rx                                  := rx_idle;         --FSM state for the rx
    signal rx_reg         : std_logic_vector((bits_per_word - 1) downto 0) := (others => '1'); --RX register
    signal rx_bit_counter : integer range 0 to 15                          := 0;               --bit counter
    signal rx_counter_rst : std_logic                                      := '0';             --reset signal for the bit counter
    signal rx_uart_clk    : std_logic                                      := '0';             --clock for correct transmittion delay
    --tx signals
    type state_type_tx is (tx_idle, tx_starting, tx_sending, tx_finished);
    signal tx_state          : state_type_tx                                 := tx_idle;         --FSM state for the tx
    signal tx_reg            : std_logic_vector((bits_per_package) downto 0) := (others => '1'); --register: bits/message + stop bit + parity bit
    signal tx_bit_counter    : integer range 0 to 15                         := 0;               --bit counter
    signal tx_counter_rst    : std_logic                                     := '0';             --reset signal for the bit counter
    signal tx_start_internal : std_logic                                     := '0';             --internal starting signal for the tx
    signal tx_parity_bit     : std_logic                                     := '0';             --parity bit   
    signal tx_uart_clk       : std_logic                                     := '0';             --clock for correct sampling

    --components
begin
    ------------------------------------------------------------------------------
    --static casts
    ------------------------------------------------------------------------------
    sampling_delay <= cfg_clkSpeed_over_bdRate;

    ------------------------------------------------------------------------------
    --entities
    ------------------------------------------------------------------------------
    uart_clk_rx_ent : uart_clock
    port map(
        I_clk            => clk,
        I_reset          => rx_counter_rst,
        I_sampling_delay => sampling_delay,
        O_clk            => rx_uart_clk
    );
    uart_clk_tx_ent : uart_clock
    port map(
        I_clk            => clk,
        I_reset          => '0', --we never need to reset this clock
        I_sampling_delay => sampling_delay,
        O_clk            => tx_uart_clk
    );

    ------------------------------------------------------------------------------
    --RX
    ------------------------------------------------------------------------------
    -- FSM for the RX  flow contro
    fsm_rx_process : process (clk) begin
        if (rising_edge(clk)) then
            case rx_state is
                when rx_idle => --idle until a starting bit (0) arrives
                    rx_counter_rst <= '0';
                    if (rx_data = '0') then
                        rx_state <= rx_starting;
                    else
                        rx_state <= rx_idle;
                    end if;
                when rx_starting =>    -- start receiving
                    rx_counter_rst <= '1'; --reset counter
                    rx_state       <= rx_receiving;
                when rx_receiving =>   --during receving: if receiving is finished, go to finished state and reset counter, else keep on receiving
                    rx_counter_rst <= '0'; --release counter reset
                    if (rx_bit_counter >= bits_per_package) then
                        rx_state <= rx_finished;
                    else
                        null;
                    end if;
                when rx_finished =>
                    rx_counter_rst <= '0';
                when others => null;
            end case;
        end if;
    end process;

    --set and release the RX finished signal
    rx_finished_process : process (all) begin
        case rx_state is
            when rx_idle =>
                rx_finished_out <= rx_finished_out;
            when rx_starting =>
                rx_finished_out <= '0';
            when rx_receiving =>
                rx_finished_out <= '0';
            when rx_finished =>
                rx_finished_out <= '1';
            when others =>
                rx_finished_out <= '0';
        end case;
    end process;

    -- Counter for the RX FSM  
    rx_counter_process : process (rx_uart_clk, rx_counter_rst) begin
        if rx_counter_rst = '1' then
            rx_bit_counter <= 0;
            elsif rising_edge(rx_uart_clk) then
            rx_bit_counter <= rx_bit_counter + 1;
        end if;
    end process;

    -- RX data flow
    rx_data_process : process (rx_uart_clk) begin
        if (rising_edge(rx_uart_clk)) then
            if (rx_bit_counter > 0) then
                rx_reg(rx_bit_counter - 1) <= rx_data;
            end if;
        end if;
    end process;

    ------------------------------------------------------------------------------
    --TX
    ------------------------------------------------------------------------------
    -- FSM for the TX  flow control
    fsm_tx_process : process (clk) begin
        if (rising_edge(clk)) then
            case tx_state is
                when tx_idle => --idle until a starting bit (0) arrives
                    tx_counter_rst <= '0';
                    if (tx_start_internal = '1') then
                        tx_state <= tx_starting;
                    else
                        tx_state <= tx_idle;
                    end if;
                when tx_starting =>    --start receiving
                    tx_counter_rst <= '1'; --reset counter
                    tx_state       <= tx_sending;
                when tx_sending =>                           --during receving: if transmitting is finished, go to finished state and reset counter, else keep on transmitting
                    tx_counter_rst <= '0';                       --release counter reset
                    if (tx_bit_counter >= bits_per_package) then --bits per message + starting bit + ending bit + parity bit - starting at 0
                        tx_state <= tx_finished;
                    else
                        null;
                    end if;
                when tx_finished =>
                    tx_counter_rst <= '0';
                when others => null;
            end case;
        end if;
    end process;

    --set and release in internal TX starting signal
    tx_start_internal_process : process (clk) begin
        if (rising_edge(clk)) then
            if (tx_start = '1') and tx_state = tx_idle then
                tx_start_internal <= '1';
                else
                tx_start_internal <= '0';
            end if;
        end if;
    end process;

    --set and release the TX ready signal
    tx_ready_process : process (all) begin
        case tx_state is
            when tx_starting =>
                tx_ready <= '0';
            when tx_sending =>
                tx_ready <= '0';
            when others =>
                tx_ready <= '1';
        end case;
    end process;

    -- Counter for the TX FSM
    tx_counter_process : process (tx_uart_clk, tx_counter_rst) begin
        if tx_counter_rst = '1' then
            tx_bit_counter <= 0;
            elsif rising_edge(tx_uart_clk) then
            tx_bit_counter <= tx_bit_counter + 1;
        end if;
    end process;

    -- TX data flow
    tx_data_process : process (tx_uart_clk, rst) begin
        if (rising_edge(tx_uart_clk)) then
            tx_data_out <= tx_reg(bits_per_package - tx_bit_counter);
        end if;
    end process;

    --build the TX register from the input word
    tx_reg_process : process (all) begin
        tx_reg <= '1' & tx_parity_bit & tx_data_word & '0'; --start bit, parity bit, data bits, stop bit
    end process;

    --handle the parity bit in the TX 
    tx_parity_bit_process : process (clk) begin
        if rising_edge(clk) then
            if (tx_state = tx_starting) then
                if (cfg_parity_setting = "00") then
                    tx_parity_bit <= '1'; -- no parity
                    elsif (cfg_parity_setting = "01") then
                    tx_parity_bit <= xnor_reduce(tx_data_word); -- even parity
                    elsif (cfg_parity_setting = "10") then
                    tx_parity_bit <= xor_reduce(tx_data_word); -- odd parity
                    else
                    tx_parity_bit <= '1'; -- no parity
                end if;
            end if;
        end if;
    end process;
end architecture behav;