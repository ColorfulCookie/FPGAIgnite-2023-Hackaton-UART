LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_misc.ALL;
ENTITY uartus IS
    PORT (
        I_clk                      : IN  STD_LOGIC                     := '1'; --clock
        I_rst                      : IN  STD_LOGIC                     := '0'; --reset is high active
        O_tx_data                  : OUT STD_LOGIC                    := '1'; --transmission bit output (Tx) (continuous 1 for 'off')
        O_tx_ready                 : OUT STD_LOGIC                    := '0'; -- port for signaling begin ready to transmit a new data word
        I_tx_data_word             : IN  STD_LOGIC_VECTOR(7 DOWNTO 0)  := (OTHERS => '1'); --transmission word (Tx) (continuous 1 for 'off')
        I_tx_start                 : IN  STD_LOGIC                     := '0'; -- signal to start transmission
        I_rx_data                  : IN  STD_LOGIC                     := '1'; --receiving bit (Rx) (continuous 1 for 'off')
        O_rx_finished              : OUT STD_LOGIC                    := '0'; --port for signaling having finished receiving a data word
        O_rx_data_word             : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '1'); --tx data word output
        I_cfg_parity_setting       : IN  STD_LOGIC_VECTOR(1 DOWNTO 0)  := "00"; -- 00 -> parity off, 01-> parity even, 10-> parity odd
        I_cfg_clkSpeed_over_bdRate : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(87, 32)) -- sets the effective baudrate; clk/bd, e.g. for a 10MHz clk and with 115.2k Bd: 10 000 000 / 115 200 = 86.8
        -- bits_per_word: integer := 8;--nr of data bits in each transmission; hardcoded to 8 
    );
END ENTITY uartus;

ARCHITECTURE behav OF uartus IS
    ------------------------------------------------------------------------------
    --components
    ------------------------------------------------------------------------------
    COMPONENT uart_clock IS
        PORT (
            I_clk            : IN  STD_LOGIC;
            I_reset          : IN  STD_LOGIC;
            I_sampling_delay : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            O_clk            : OUT STD_LOGIC
        );
    END COMPONENT;
    ------------------------------------------------------------------------------
    --constants, variables, signals
    ------------------------------------------------------------------------------
    --constant design variables
    CONSTANT bits_per_word    : INTEGER RANGE 0 TO 8  := 8;
    CONSTANT bits_per_package : INTEGER RANGE 0 TO 15 := bits_per_word + 3; --number of bits in each package: bits per message + starting bit + parity bit + ending bit
    --design variables
    SIGNAL sampling_delay : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    --rx signals
    TYPE state_type_rx IS (rx_idle, rx_starting, rx_receiving, rx_finished);
    SIGNAL rx_state       : state_type_rx                                  := rx_idle; --FSM state for the rx
    SIGNAL rx_reg         : STD_LOGIC_VECTOR((bits_per_word - 1) DOWNTO 0) := (OTHERS => '1'); --RX register
    SIGNAL rx_bit_counter : INTEGER RANGE 0 TO 63                          := 0; --bit counter
    SIGNAL rx_counter_rst : STD_LOGIC                                      := '0'; --reset signal for the bit counter
    SIGNAL rx_uart_clk    : STD_LOGIC                                      := '0'; --clock for correct transmission delay
    --tx signals
    TYPE state_type_tx IS (tx_idle, tx_starting, tx_sending, tx_finished);
    SIGNAL tx_state          : state_type_tx                                     := tx_idle; --FSM state for the tx
    SIGNAL tx_reg            : STD_LOGIC_VECTOR((bits_per_package - 1) DOWNTO 0) := (OTHERS => '1'); --register: bits/message + stop bit + parity bit
    SIGNAL tx_bit_counter    : INTEGER RANGE 0 TO 15                             := 0; --bit counter
    SIGNAL tx_counter_rst    : STD_LOGIC                                         := '0'; --reset signal for the bit counter
    SIGNAL tx_start_internal : STD_LOGIC                                         := '0'; --internal starting signal for the tx
    -- signal tx_parity_bit     : std_logic                                         := '0';             --parity bit   
    SIGNAL tx_uart_clk : STD_LOGIC := '0'; --clock for correct sampling

    --components
BEGIN
    ------------------------------------------------------------------------------
    --static casts
    ------------------------------------------------------------------------------
    sampling_delay <= I_cfg_clkSpeed_over_bdRate;

    ------------------------------------------------------------------------------
    --entities
    ------------------------------------------------------------------------------
    uart_clk_rx_ent : uart_clock
    PORT MAP(
        I_clk            => I_clk,
        I_reset          => rx_counter_rst,
        I_sampling_delay => sampling_delay,
        O_clk            => rx_uart_clk
    );
    uart_clk_tx_ent : uart_clock
    PORT MAP(
        I_clk            => I_clk,
        I_reset          => '0', --we never need to reset this clock
        I_sampling_delay => sampling_delay,
        O_clk            => tx_uart_clk
    );

    ------------------------------------------------------------------------------
    --RX
    ------------------------------------------------------------------------------
    -- FSM for the RX  flow contro
    fsm_rx_process : PROCESS (I_clk) BEGIN
        IF (rising_edge(I_clk)) THEN
            IF (I_rst = '1') THEN
                rx_state <= rx_idle;
            ELSE
                CASE rx_state IS
                    WHEN rx_idle => --idle until a starting bit (0) arrives
                        rx_counter_rst <= '0';
                        IF (I_rx_data = '0') THEN
                            rx_state <= rx_starting;
                        ELSE
                            rx_state <= rx_idle;
                        END IF;
                    WHEN rx_starting => -- start receiving
                        rx_counter_rst <= '1'; --reset counter
                        rx_state       <= rx_receiving;
                    WHEN rx_receiving => --during receving: if receiving is finished, go to finished state and reset counter, else keep on receiving
                        rx_counter_rst <= '0'; --release counter reset
                        IF (rx_bit_counter >= (bits_per_package - 1)) THEN
                            rx_state <= rx_finished;
                        ELSE
                            NULL;
                        END IF;
                    WHEN rx_finished =>
                        rx_counter_rst <= '0';
                        rx_state       <= rx_idle;
                    WHEN OTHERS => NULL;
                END CASE;
            END IF;
        END IF;
    END PROCESS;

    --set and release the RX finished signal
    rx_finished_process : PROCESS (I_clk) BEGIN
        IF (rising_edge(I_clk)) THEN
            IF (I_rst = '1') THEN
                O_rx_finished <= '0';
            ELSE
                CASE rx_state IS
                    WHEN rx_idle =>
                        O_rx_finished  <= O_rx_finished;
                        O_rx_data_word <= O_rx_data_word;
                    WHEN rx_starting =>
                        O_rx_finished  <= '0';
                        O_rx_data_word <= O_rx_data_word;
                    WHEN rx_receiving =>
                        O_rx_finished  <= '0';
                        O_rx_data_word <= O_rx_data_word;
                    WHEN rx_finished =>
                        O_rx_finished  <= '1';
                        O_rx_data_word <= rx_reg;
                    WHEN OTHERS =>
                        O_rx_finished  <= '0';
                        O_rx_data_word <= O_rx_data_word;
                END CASE;
            END IF;
        END IF;
    END PROCESS;

    -- Counter for the RX FSM  
    rx_counter_process : PROCESS (rx_uart_clk, rx_counter_rst) BEGIN
        IF (rx_counter_rst = '1') THEN
            rx_bit_counter <= 0;
        ELSIF (rising_edge(rx_uart_clk)) THEN
            IF (rx_state = rx_receiving) THEN
                rx_bit_counter <= rx_bit_counter + 1;
            END IF;
        END IF;
    END PROCESS;

    -- RX data flow
    rx_data_in_process : PROCESS (rx_uart_clk) BEGIN
        IF (rising_edge(rx_uart_clk)) THEN
            IF (I_rst = '1') THEN
                rx_reg <= (OTHERS => '1');
            ELSIF (rx_bit_counter > 8 OR rx_bit_counter < 1) THEN
                NULL;
            ELSIF (rx_bit_counter > 0) THEN
                rx_reg(rx_bit_counter - 1) <= I_rx_data;
            ELSE
                NULL;
            END IF;
        END IF;
    END PROCESS;

    ------------------------------------------------------------------------------
    --TX
    ------------------------------------------------------------------------------
    -- FSM for the TX  flow control
    fsm_tx_process : PROCESS (I_clk) BEGIN
        IF (rising_edge(I_clk)) THEN
            IF (I_rst = '1') THEN
                tx_state <= tx_idle;
            ELSE
                CASE tx_state IS
                    WHEN tx_idle => --idle until a starting bit (0) arrives
                        tx_counter_rst <= '0';
                        IF (tx_start_internal = '1') THEN
                            tx_state <= tx_starting;
                        ELSE
                            tx_state <= tx_idle;
                        END IF;
                    WHEN tx_starting => --start receiving
                        tx_counter_rst <= '1'; --reset counter
                        tx_state       <= tx_sending;
                    WHEN tx_sending => --during receving: if transmitting is finished, go to finished state and reset counter, else keep on transmitting
                        tx_counter_rst     <= '0'; --release counter reset
                        IF (tx_bit_counter <= (bits_per_package)) THEN
                            NULL;
                        ELSE
                            tx_state <= tx_finished;
                        END IF;
                    WHEN tx_finished =>
                        tx_counter_rst <= '0';
                        tx_state       <= tx_idle;
                    WHEN OTHERS => NULL;
                END CASE;
            END IF;
        END IF;
    END PROCESS;

    --set and release in internal TX starting signal
    tx_start_internal_process : PROCESS (I_clk) BEGIN
        IF (rising_edge(I_clk)) THEN
            IF (I_rst = '1') THEN
                tx_start_internal <= '0';
            ELSIF ((I_tx_start = '1') AND (tx_state = tx_idle)) THEN
                tx_start_internal <= '1';
            ELSE
                tx_start_internal <= '0';
            END IF;
        END IF;
    END PROCESS;

    --set and release the TX ready signal
    tx_ready_process : PROCESS (I_clk) BEGIN
        CASE tx_state IS
            WHEN tx_starting =>
                O_tx_ready <= '0';
            WHEN tx_sending =>
                O_tx_ready <= '0';
            WHEN OTHERS =>
                O_tx_ready <= '1';
        END CASE;
    END PROCESS;

    -- Counter for the TX FSM
    tx_counter_process : PROCESS (tx_uart_clk, tx_counter_rst) BEGIN
        IF tx_counter_rst = '1' THEN
            tx_bit_counter <= 0;
        ELSIF rising_edge(tx_uart_clk) THEN
            IF (tx_state = tx_sending) THEN
                tx_bit_counter <= tx_bit_counter + 1;
            END IF;
        END IF;
    END PROCESS;

    -- TX data flow
    tx_data_process : PROCESS (tx_uart_clk, I_rst) BEGIN
        IF (rising_edge(tx_uart_clk)) THEN
            IF (I_rst = '1') THEN
                O_tx_data <= '1';
            ELSIF ((tx_bit_counter <= bits_per_package) AND (tx_bit_counter > 0)) THEN
                O_tx_data <= tx_reg(tx_bit_counter - 1);
                REPORT INTEGER'image(tx_bit_counter);
            ELSE
                NULL;
            END IF;
        END IF;
    END PROCESS;

    --build the TX register from the input word and handle the parity bit 
    tx_reg_process : PROCESS (I_tx_data_word) BEGIN
        IF (I_cfg_parity_setting = "00") THEN --no parity
            tx_reg <= '1' & '1' & I_tx_data_word & '0'; --stop bit, parity bit, data bits, start bit
        ELSIF (I_cfg_parity_setting = "11") THEN --no parity
            tx_reg <= '1' & '1' & I_tx_data_word & '0'; --stop bit, parity bit, data bits, start bit
        ELSIF (I_cfg_parity_setting = "01") THEN --even parity
            tx_reg <= '1' & xnor_reduce(I_tx_data_word) & I_tx_data_word & '0'; --stop bit, parity bit, data bits, start bit
        ELSIF (I_cfg_parity_setting = "10") THEN --odd parity
            tx_reg <= '1' & xor_reduce(I_tx_data_word) & I_tx_data_word & '0'; --stop bit, parity bit, data bits, start bit
        ELSE --no parity
            tx_reg <= '1' & '1' & I_tx_data_word & '0'; --stop bit, parity bit, data bits, start bit
        END IF;
    END PROCESS;

END ARCHITECTURE behav;