LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY register_file IS
    GENERIC (
        g_register_count : INTEGER := 32
    );
    PORT (
        i_clk             : IN  STD_LOGIC;
        i_reset           : IN  STD_LOGIC;
        i_increment_pulse : IN  STD_LOGIC;
        i_write_enable    : IN  STD_LOGIC;
        i_word_in         : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        o_word_out        : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END ENTITY register_file;

ARCHITECTURE rtl OF register_file IS
    TYPE t_register_array IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    TYPE t_state IS (s_write, s_read);
    SIGNAL s_state            : t_state                                 := s_write;
    SIGNAL r_register         : t_register_array                        := (OTHERS => (OTHERS => '0'));
    SIGNAL s_register_counter : INTEGER RANGE 0 TO g_register_count - 1 := 0;

BEGIN
    s_register_counter_process : PROCESS (i_clk)
    BEGIN
        IF rising_edge(i_clk) THEN
            IF i_reset = '1' THEN
                s_register_counter <= 0;
                ELSIF i_increment_pulse = '1' THEN
                IF s_register_counter = g_register_count - 1 THEN
                    s_register_counter <= 0;
                    ELSE
                    s_register_counter <= s_register_counter + 1;
                END IF;
                ELSE
                s_register_counter <= s_register_counter;
            END IF;
        END IF;
    END PROCESS s_register_counter_process;

    o_word_out_process : PROCESS (ALL)
    BEGIN
        o_word_out <= r_register(s_register_counter);
    END PROCESS o_word_out_process;

    r_register_process : PROCESS (ALL)
    BEGIN
        IF i_write_enable = '1' THEN
            r_register(s_register_counter) <= i_word_in;
        END IF;
    END PROCESS r_register_process;

END ARCHITECTURE;