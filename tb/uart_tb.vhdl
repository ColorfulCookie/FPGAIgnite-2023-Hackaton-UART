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
            tx_data                  : out std_logic                    := '1';             --transmission bit output (Tx) (continuous 1 for 'off')
            tx_ready                 : out std_logic                    := '0';             -- port for signaling begin ready to transmit a new data word
            tx_data_word             : out std_logic_vector(7 downto 0) := (others => '1'); --transmission word (Tx) (continuous 1 for 'off')
            tx_start                 : in std_logic                     := '0';
            rx_data                  : in std_logic                     := '1';                                  --receiving bit (Rx) (continuous 1 for 'off')
            rx_finished_out          : out std_logic                    := '0';                                  -- port for signaling having finished receiving a data word
            cfg_parity_setting       : in std_logic_vector(1 downto 0)  := "00";                                 -- 00 -> parity off, 01-> parity even, 10-> parity odd
            cfg_clkSpeed_over_bdRate : in std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(87, 32)) -- sets the effective baudrate; clk/bd, e.g. for a 10MHz clk and with 115.2k Bd: 10 000 000 / 115 200 = 86.8
            -- bits_per_msg: integer := 8;--nr of data bits in each transmission; hardcoded to 8 
        );
    end component uart;
begin

end architecture;