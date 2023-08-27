LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY register_file_tb IS
END ENTITY register_file_tb;

ARCHITECTURE rtl OF register_file_tb IS
    --
    -- Components
    --
    COMPONENT register_file IS
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
    END COMPONENT register_file;

    -- 
    -- Signals
    -- 
    TYPE t_test_states IS (initial, test_A, test_B, test_C, test_D, test_E);
    SIGNAL test_state : t_test_states := initial;

    CONSTANT c_register_count : INTEGER := 32;
    CONSTANT c_clk_period     : TIME    := 10 ns;

    SIGNAL i_clk             : STD_LOGIC                    := '0';
    SIGNAL i_reset           : STD_LOGIC                    := '0';
    SIGNAL i_increment_pulse : STD_LOGIC                    := '0';
    SIGNAL i_write_enable    : STD_LOGIC                    := '0';
    SIGNAL i_word_in         : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL o_word_out        : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL test_signal       : STD_LOGIC                    := '0';

    SIGNAL s_internal_register_counter : INTEGER RANGE 0 TO 32 - 1 := 0;
    --
    -- Procedures
    --
    PROCEDURE wait_until_time (time_amt : IN TIME) IS
        VARIABLE time_to_wait : TIME;
    BEGIN
        time_to_wait := time_amt - NOW;
        IF time_to_wait > 0 ns THEN
            WAIT FOR time_to_wait;
        END IF;
    END PROCEDURE wait_until_time;

BEGIN
    i_clk <= NOT i_clk AFTER c_clk_period/2;

    s_internal_register_counter <= << SIGNAL .register_file_tb.uut.s_register_counter : INTEGER RANGE 0 TO 32 - 1 >> ;

    uut : register_file
    GENERIC MAP(
        g_register_count => c_register_count
    )
    PORT MAP(
        i_clk             => i_clk,
        i_reset           => i_reset,
        i_increment_pulse => i_increment_pulse,
        i_write_enable    => i_write_enable,
        i_word_in         => i_word_in,
        o_word_out        => o_word_out
    );

    PROCESS
        PROCEDURE increment_counter (increment_amount : IN INTEGER) IS
        BEGIN
            FOR i IN 1 TO increment_amount LOOP
                WAIT UNTIL rising_edge(i_clk);
                i_increment_pulse <= '1';
                WAIT UNTIL rising_edge(i_clk);
                i_increment_pulse <= '0';
                WAIT FOR 1 us;
            END LOOP;
        END PROCEDURE increment_counter;

        PROCEDURE fill_register_file_ascend (start_value : IN INTEGER) IS
        BEGIN
            FOR i IN 0 TO c_register_count - 1 LOOP
                i_write_enable <= '1';
                i_word_in      <= STD_LOGIC_VECTOR(to_unsigned(start_value + i, 8));
                WAIT UNTIL rising_edge(i_clk);
                i_write_enable <= '0';
                increment_counter(1);
                WAIT UNTIL rising_edge(i_clk);
            END LOOP;
        END PROCEDURE fill_register_file_ascend;
    BEGIN
        ---------
        -- Test A: Incrementing the counter by 5
        ---------
        wait_until_time(100 us);
        test_state <= test_A;
        increment_counter(5);
        WAIT FOR 10 ns;
        ASSERT s_internal_register_counter = 5 REPORT "Counter value is not 5" SEVERITY error;
        REPORT "Test A passed";

        ---------
        -- Test B: Incrementing the counter by 50 - more than the counter size
        ---------
        wait_until_time(200 us);
        test_state <= test_B;
        i_reset    <= '1';
        WAIT UNTIL rising_edge(i_clk);
        i_reset <= '0';
        increment_counter(50);
        WAIT FOR 10 ns;
        ASSERT s_internal_register_counter = 50 MOD c_register_count REPORT "Counter value is not 50 mod 32" SEVERITY error;
        REPORT "Test B passed";

        ---------
        -- Test C: Incrementing the counter by 100 - more than the counter size
        ---------
        WAIT_until_time(300 us);
        test_state <= test_C;
        i_reset    <= '1';
        WAIT UNTIL rising_edge(i_clk);
        i_reset <= '0';
        increment_counter(100);
        WAIT FOR 10 ns;
        ASSERT s_internal_register_counter = 100 MOD c_register_count REPORT "Counter value is not 100 mod 32" SEVERITY error;
        REPORT "Test C passed";

        ----------
        -- Test D: Writing to the register file
        ----------
        WAIT_until_time(500 us);
        test_state <= test_D;
        i_reset    <= '1';
        WAIT UNTIL rising_edge(i_clk);
        i_reset <= '0';
        WAIT UNTIL rising_edge(i_clk);
        fill_register_file_ascend(10);
        WAIT FOR 10 ns;
        ASSERT o_word_out = STD_LOGIC_VECTOR(to_unsigned(10, 8)) REPORT "Register 0 does not contain 10" SEVERITY error;
        REPORT "Test D passed";

        -------------
        -- Test E: Reading from the register file
        -------------
        wait_until_time(600 us);
        test_state <= test_E;
        increment_counter(10);
        WAIT FOR 10 ns;
        ASSERT o_word_out = STD_LOGIC_VECTOR(to_unsigned(20, 8)) REPORT "Register 10 does not contain 20" SEVERITY error;
        increment_counter(21);
        WAIT FOR 10 ns;
        ASSERT o_word_out = STD_LOGIC_VECTOR(to_unsigned(41, 8)) REPORT "Register 31 does not contain 41" SEVERITY error;
        REPORT "Test E passed";
        WAIT;
    END PROCESS;
END ARCHITECTURE;