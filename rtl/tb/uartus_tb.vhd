library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uartus_tb is
end entity uartus_tb;

architecture rtl of uartus_tb is
    component uartus is
        port (
            clk                      : in std_logic                     := '1';                                  --clock
            rst                      : in std_logic                     := '0';                                  --reset is high active
            tx_data_out              : out std_logic                    := '1';                                  --transmission bit output (Tx) (continuous 1 for 'off')
            tx_ready                 : out std_logic                    := '0';                                  -- port for signaling begin ready to transmit a new data word
            tx_data_word_in          : in std_logic_vector(7 downto 0)  := (others => '1');                      --transmission word (Tx) (continuous 1 for 'off')
            tx_start                 : in std_logic                     := '0';                                  -- signal to start transmission
            rx_data_in               : in std_logic                     := '1';                                  --receiving bit (Rx) (continuous 1 for 'off')
            rx_finished_out          : out std_logic                    := '0';                                  --port for signaling having finished receiving a data word
            rx_data_word_out         : out std_logic_vector(7 downto 0) := (others => '1');                      --tx data word output
            cfg_parity_setting       : in std_logic_vector(1 downto 0)  := "00";                                 -- 00 -> parity off, 01-> parity even, 10-> parity odd
            cfg_clkSpeed_over_bdRate : in std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(87, 32)) -- sets the effective baudrate; clk/bd, e.g. for a 10MHz clk and with 115.2k Bd: 10 000 000 / 115 200 = 86.8
            -- bits_per_word: integer := 8;--nr of data bits in each transmission; hardcoded to 8 
        );
    end component uartus;
    constant c_bit_period             : time                          := ((10000000/115200) * 100 ns); -- 115.2k Bd
    constant clk_period               : time                          := 100 ns;                       --10MHz
    signal s_clk                      : std_logic                     := '1';
    signal s_rst                      : std_logic                     := '0';
    signal s_tx_data                  : std_logic                     := '1';
    signal s_tx_ready                 : std_logic                     := '0';
    signal s_tx_data_word_in          : std_logic_vector(7 downto 0)  := (others => '1');
    signal s_tx_start                 : std_logic                     := '0';
    signal s_rx_data_in               : std_logic                     := '1';
    signal s_rx_finished_out          : std_logic                     := '0';
    signal s_rx_data_word_out         : std_logic_vector(7 downto 0)  := (others => '1');
    signal s_cfg_parity_setting       : std_logic_vector(1 downto 0)  := "00";
    signal s_cfg_clkSpeed_over_bdRate : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned((10000000/115200), 32));

    procedure send_uart_data(s_rx_test_data : in std_logic_vector(7 downto 0); signal s_rx_data : out std_logic) is
    begin
        s_rx_data <= '0'; --starting bit
        wait for c_bit_period;
        for i in 0 to 7 loop --data word
            s_rx_data <= s_rx_test_data(i);
            wait for c_bit_period;
        end loop;
        s_rx_data <= '1'; --end bit
        wait for c_bit_period;
    end procedure;

begin
    s_clk <= not s_clk after clk_period/2;

    uut : uartus
    port map(
        clk                      => s_clk,
        rst                      => s_rst,
        tx_data_out              => s_tx_data,
        tx_ready                 => s_tx_ready,
        tx_data_word_in          => s_tx_data_word_in,
        tx_start                 => s_tx_start,
        rx_data_in               => s_rx_data_in,
        rx_finished_out          => s_rx_finished_out,
        rx_data_word_out         => s_rx_data_word_out,
        cfg_parity_setting       => s_cfg_parity_setting,
        cfg_clkSpeed_over_bdRate => s_cfg_clkSpeed_over_bdRate
    );
    --tx and rx tests, half duplex test
    --for full duplex test ist below
    process
    begin
        wait for clk_period;
        s_rst <= '1';
        wait for clk_period;
        s_rst <= '0';
        wait for clk_period;
        --debug RX
        send_uart_data(x"AA", s_rx_data_in);
        send_uart_data(x"FF", s_rx_data_in);
        send_uart_data(x"B9", s_rx_data_in);
        send_uart_data(x"00", s_rx_data_in);
        --debug TX with odd parity
        wait for clk_period * 10;
        s_cfg_parity_setting <= b"10";
        s_tx_data_word_in    <= x"AA";
        s_tx_start           <= '1';
        wait for clk_period * 10;
        s_tx_start <= '0';
        wait for clk_period * 1000;
        s_cfg_parity_setting <= b"10";
        s_tx_data_word_in    <= x"FF";
        s_tx_start           <= '1';
        wait for clk_period * 10;
        s_tx_start <= '0';
        --debug TX with even parity
        wait for clk_period * 1000;
        wait for clk_period * 10;
        s_cfg_parity_setting <= b"01";
        s_tx_data_word_in    <= x"AA";
        s_tx_start           <= '1';
        wait for clk_period * 10;
        s_tx_start <= '0';
        wait for clk_period * 1000;
        s_cfg_parity_setting <= b"01";
        s_tx_data_word_in    <= x"FF";
        s_tx_start           <= '1';
        wait for clk_period * 10;
        s_tx_start           <= '0';
        s_cfg_parity_setting <= b"00";

        --debug TX timing stuff
        wait for clk_period * 3000;

        for i in 0 to 50 loop --data word
            s_tx_data_word_in <= x"AA";
            s_tx_start        <= '1';
            wait for clk_period * 10;
            s_tx_start <= '0';
            wait for clk_period * 1100;
        end loop;

        --debug half duplex
        wait for clk_period * 3000;
        for i in 0 to 25 loop --data word
            s_tx_data_word_in <= x"AA";
            send_uart_data(x"AA", s_rx_data_in);
            s_tx_start <= '1';
            wait for clk_period * 10;
            s_tx_start <= '0';
            wait for clk_period * 1100;
            s_tx_data_word_in <= x"FF";
            send_uart_data(x"FF", s_rx_data_in);
            s_tx_start <= '1';
            wait for clk_period * 10;
            s_tx_start <= '0';
            wait for clk_period * 1100;
        end loop;
        wait;
    end process;

    --for full duplex test comment process above and uncomment the following two processes

    -- full_duplex_tx : process
    -- begin
    --     for i in 0 to 25 loop --data word
    --         s_tx_data_word_in <= x"AA";
    --         s_tx_start        <= '1';
    --         wait for clk_period * 10;
    --         s_tx_start <= '0';
    --         wait for clk_period * 1100;
    --     end loop;
    --     wait;
    -- end process;

    -- full_duplex_rx : process
    -- begin
    --     for i in 0 to 25 loop --data word
    --         send_uart_data(x"FF", s_rx_data_in);
    --     end loop;
    --     wait;
    -- end process;
end architecture;