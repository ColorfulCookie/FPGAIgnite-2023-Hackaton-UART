-- A UART-Clock generator. The idea is that the UART clock is generated from the main clock.
-- To ensure that the UART clock is still correct when recieving data, the UART clock
-- can be reset if a start bit is detected. Because this always happens for each sent byte, 
-- the UART clock will always be in sync with the data.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_clock is
    port (
        I_clk            : in std_logic;
        I_reset          : in std_logic;
        I_sampling_delay : in std_logic_vector(31 downto 0);
        O_clk            : out std_logic
    );
end entity uart_clock;

architecture rtl of uart_clock is
    signal s_clk     : std_logic                      := '0';
    signal s_counter : integer range 0 to 2 ** 32 - 1 := 0;
begin
    O_clk_process : process (I_clk, I_reset)
    begin
        if I_reset = '1' then
            s_clk <= '0';
            elsif falling_edge(I_clk) then
            -- if s_counter = g_clk_freq / g_baud_rate / 2 - 1 then
            if s_counter = to_integer(unsigned(I_sampling_delay)) / 2 - 1 then
                s_clk     <= not s_clk;
                s_counter <= 0;
                else
                s_counter <= s_counter + 1;
            end if;
        end if;
    end process O_clk_process;
    O_clk <= s_clk;
end architecture;