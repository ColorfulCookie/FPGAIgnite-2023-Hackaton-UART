-- A UART-Clock generator. The idea is that the UART clock is generated from the main clock.
-- To ensure that the UART clock is still correct when recieving data, the UART clock
-- can be reset if a start bit is detected. Because this always happens for each sent byte, 
-- the UART clock will always be in sync with the data.
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY uart_clock IS
    GENERIC (
        g_clk_freq : INTEGER := 12_000_000;
        g_baud_rate : INTEGER := 115_200
    );
    PORT (
        I_clk : IN STD_LOGIC;
        I_reset : IN STD_LOGIC;
        O_clk : OUT STD_LOGIC
    );
END ENTITY uart_clock;
ARCHITECTURE rtl OF uart_clock IS
    SIGNAL s_clk : STD_LOGIC := '0';
    SIGNAL s_counter : INTEGER RANGE 0 TO g_clk_freq / g_baud_rate / 2 - 1 := 0;
BEGIN
    O_clk_process : PROCESS (I_clk, I_reset)
    BEGIN
        IF I_reset = '1' THEN
            s_clk <= '0';
        ELSIF falling_edge(I_clk) THEN
            IF s_counter = g_clk_freq / g_baud_rate / 2 - 1 THEN
                s_clk <= NOT s_clk;
                s_counter <= 0;
            ELSE
                s_counter <= s_counter + 1;
            END IF;
        END IF;
    END PROCESS O_clk_process;
    O_clk <= s_clk;
END ARCHITECTURE;