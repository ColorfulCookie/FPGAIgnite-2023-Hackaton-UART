-- Just a generic edge detector for VHDL
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY edge_detector IS
    GENERIC (
        g_rising : STD_LOGIC := '1';
        g_falling : STD_LOGIC := '0'
    );
    PORT (
        clk : IN STD_LOGIC;
        I_signal : IN STD_LOGIC;
        O_edge_pulse : OUT STD_LOGIC
    );
END ENTITY edge_detector;

ARCHITECTURE rtl OF edge_detector IS

    TYPE state_t IS (HIGH, LOW, FALLING, RISING);
    SIGNAL state : state_t := LOW;

BEGIN

    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            CASE state IS
                WHEN LOW =>
                    IF I_signal = '1' THEN
                        state <= RISING;
                    END IF;
                WHEN HIGH =>
                    IF I_signal = '0' THEN
                        state <= FALLING;
                    END IF;
                WHEN FALLING =>
                    state <= LOW;
                WHEN RISING =>
                    state <= HIGH;
                WHEN OTHERS =>
                    state <= LOW;
            END CASE;
        END IF;
    END PROCESS;

    output_process : PROCESS (ALL)
    BEGIN
        CASE state IS
            WHEN LOW =>
                O_edge_pulse <= '0';
            WHEN HIGH =>
                O_edge_pulse <= '0';
            WHEN RISING =>
                O_edge_pulse <= g_rising;
            WHEN FALLING =>
                O_edge_pulse <= g_falling;
            WHEN OTHERS =>
                O_edge_pulse <= '0';
        END CASE;
    END PROCESS;
END ARCHITECTURE;