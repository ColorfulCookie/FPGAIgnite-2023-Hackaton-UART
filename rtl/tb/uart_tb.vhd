library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tb is
end entity uart_tb;

architecture rtl of uart_tb is
    component uart is
        port (
            clk                      : in std_logic                     := '1';             --clock
            rst                      : in std_logic                     := '0';             --reset is high active
            tx_data_out              : out std_logic                    := '1';             --transmission bit output (Tx) (continuous 1 for 'off')
            tx_ready                 : out std_logic                    := '0';             -- port for signaling begin ready to transmit a new data word
            tx_data_word             : out std_logic_vector(7 downto 0) := (others => '1'); --transmission word (Tx) (continuous 1 for 'off')
            tx_start                 : in std_logic                     := '0';
            rx_data                  : in std_logic                     := '1';                                  --receiving bit (Rx) (continuous 1 for 'off')
            rx_finished_out          : out std_logic                    := '0';                                  -- port for signaling having finished receiving a data word
            cfg_parity_setting       : in std_logic_vector(1 downto 0)  := "00";                                 -- 00 -> parity off, 01-> parity even, 10-> parity odd
            cfg_clkSpeed_over_bdRate : in std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(87, 32)) -- sets the effective baudrate; clk/bd, e.g. for a 10MHz clk and with 115.2k Bd: 10 000 000 / 115 200 = 86.8
            -- bits_per_word: integer := 8;--nr of data bits in each transmission; hardcoded to 8 
        );
    end component uart;
    constant c_bit_period             : time                          := 8.68 us; -- 115.2k Bd
    signal s_clk                      : std_logic                     := '1';
    signal s_rst                      : std_logic                     := '0';
    signal s_tx_data                  : std_logic                     := '1';
    signal s_tx_ready                 : std_logic                     := '0';
    signal s_tx_data_word             : std_logic_vector(7 downto 0)  := (others => '1');
    signal s_tx_start                 : std_logic                     := '0';
    signal s_rx_data                  : std_logic                     := '1';
    signal s_rx_finished_out          : std_logic                     := '0';
    signal s_cfg_parity_setting       : std_logic_vector(1 downto 0)  := "00";
    signal s_cfg_clkSpeed_over_bdRate : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(87, 32));

    procedure send_uart_data(s_rx_test_data : in std_logic_vector(7 downto 0); signal s_rx_data : out std_logic) is
    begin
        s_rx_data <= '0';
        wait for c_bit_period;
        for i in 0 to 7 loop
            s_rx_data <= s_rx_test_data(i);
            wait for c_bit_period;
        end loop;
        s_rx_data <= '1';
        wait for c_bit_period;
    end procedure;

begin
    s_clk <= not s_clk after 10 ns;
    uut : uart
    port map(
        clk                      => s_clk,
        rst                      => s_rst,
        tx_data_out              => s_tx_data,
        tx_ready                 => s_tx_ready,
        tx_data_word             => s_tx_data_word,
        tx_start                 => s_tx_start,
        rx_data                  => s_rx_data,
        rx_finished_out          => s_rx_finished_out,
        cfg_parity_setting       => s_cfg_parity_setting,
        cfg_clkSpeed_over_bdRate => s_cfg_clkSpeed_over_bdRate
    );

    process
    begin
        wait for 100 ns;
        s_rst <= '1';
        wait for 100 ns;
        s_rst <= '0';
        wait for 100 ns;
        send_uart_data(x"AA", s_rx_data);
        send_uart_data(x"0D", s_rx_data);

        wait for c_bit_period * 10;
        s_tx_start <= '1';
        wait for c_bit_period * 10;
        s_tx_start <= '0';

    end process;

end architecture;