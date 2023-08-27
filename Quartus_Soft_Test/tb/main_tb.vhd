LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY main_tb IS
END ENTITY main_tb;

ARCHITECTURE rtl OF main_tb IS
    -------------
    -- Components
    -------------
    COMPONENT main IS
        GENERIC (
            g_cfg_clkSpeed_over_bdRate : STD_LOGIC_VECTOR(31 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(87, 32)) -- sets the effective baudrate; clk/bd, e.g. for a 10MHz clk and with 115.2k Bd: 10 000 000 / 115 200 = 86.8
        );
        PORT (
            I_clk          : IN  STD_LOGIC;
            I_rx           : IN  STD_LOGIC;
            I_button_press : IN  STD_LOGIC;
            O_tx           : OUT STD_LOGIC
        );
    END COMPONENT main;

    ----------
    -- SIGNALS
    ----------
    TYPE t_test_state IS (PRE_TEST, TEST_A, TEST_B, TEST_C, TEST_D);
    SIGNAL s_test_state : t_test_state := PRE_TEST;

    CONSTANT c_baud_rate             : INTEGER   := 115200;
    CONSTANT c_clk_speed             : INTEGER   := 10000000;
    CONSTANT c_clk_speed_over_bdRate : INTEGER   := c_clk_speed / c_baud_rate;
    CONSTANT c_clk_period            : TIME      := 1e9 * 1 ns/c_clk_speed;
    SIGNAL i_clk                     : STD_LOGIC := '0';
    SIGNAL i_rx                      : STD_LOGIC := '1';
    SIGNAL i_button_press            : STD_LOGIC := '0';
    SIGNAL o_tx                      : STD_LOGIC := '0';

    SIGNAL s_internal_rx_register        : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s_internal_button_press_pulse : STD_LOGIC                    := '0';
    SIGNAL s_internal_rx_finished_pulse  : STD_LOGIC                    := '0';
    SIGNAL s_internal_register_counter   : INTEGER RANGE 0 TO 32 - 1    := 0;
    SIGNAL s_internal_reg_out            : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s_internal_counter_reset      : STD_LOGIC                    := '0';
    ---------------
    -- procedures
    ---------------
    PROCEDURE wait_until_time (time_amt : IN TIME) IS
        VARIABLE time_to_wait : TIME;
    BEGIN
        time_to_wait := time_amt - NOW;
        IF time_to_wait > 0 ns THEN
            WAIT FOR time_to_wait;
        END IF;
    END PROCEDURE wait_until_time;

BEGIN

    i_clk                         <= NOT i_clk AFTER c_clk_period/2;
    s_internal_rx_register        <= << SIGNAL .main_tb.uut.s_rx_data_word                               : STD_LOGIC_VECTOR(7 DOWNTO 0) >> ;
    s_internal_button_press_pulse <= << SIGNAL .main_tb.uut.s_button_press_pulse                  : STD_LOGIC >> ;
    s_internal_rx_finished_pulse  <= << SIGNAL .main_tb.uut.s_rx_finished_pulse                    : STD_LOGIC >> ;
    s_internal_register_counter   <= << SIGNAL .main_tb.uut.register_file_module.s_register_counter : INTEGER RANGE 0 TO 32 - 1 >> ;
    s_internal_reg_out            <= << SIGNAL .main_tb.uut.s_reg_out                                        : STD_LOGIC_VECTOR(7 DOWNTO 0) >> ;
    s_internal_counter_reset      <= << SIGNAL .main_tb.uut.register_file_module.s_counter_reset       : STD_LOGIC >> ;

    uut : main
    GENERIC MAP(
        g_cfg_clkSpeed_over_bdRate => STD_LOGIC_VECTOR(to_unsigned(c_clk_speed / c_baud_rate, 32))
    )
    PORT MAP(
        i_clk          => i_clk,
        i_rx           => i_rx,
        i_button_press => i_button_press,
        o_tx           => o_tx
    );

    PROCESS IS
        PROCEDURE rx_byte (byte : IN STD_LOGIC_VECTOR(7 DOWNTO 0)) IS
        BEGIN
            i_rx <= '0';
            WAIT FOR c_clk_speed_over_bdRate * 100 ns;
            FOR i IN 0 TO 7 LOOP
                i_rx <= byte(i);
                WAIT FOR c_clk_speed_over_bdRate * 100 ns;
            END LOOP;
            i_rx <= '1';
            WAIT FOR c_clk_speed_over_bdRate * 100 ns;
        END PROCEDURE rx_byte;

        PROCEDURE check_rx_register (expected_value : IN STD_LOGIC_VECTOR(7 DOWNTO 0)) IS
        BEGIN
            ASSERT s_internal_rx_register = expected_value REPORT "Expected value not received" SEVERITY FAILURE;
            REPORT "Expected value received";
        END PROCEDURE check_rx_register;
    BEGIN
        ---------
        -- Test A - sending character sequence "AB" with long pauses in between
        ---------
        WAIT_until_time(100 us);
        s_test_state <= TEST_A;
        rx_byte(X"41"); -- A
        check_rx_register(X"41");

        WAIT_until_time(250 us);
        rx_byte(X"42"); -- B
        check_rx_register(X"42");

        WAIT_until_time(400 us);
        rx_byte(X"0d"); -- B
        check_rx_register(X"0d");
        REPORT "Test A passed";

        ----------
        -- Test B - sending character sequence "AB" with short pauses in between
        ----------
        WAIT_until_time(500 us);
        s_test_state <= TEST_B;
        rx_byte(X"41"); -- A
        check_rx_register(X"41");
        rx_byte(X"42"); -- B
        check_rx_register(X"42");
        rx_byte(X"0d"); -- B
        check_rx_register(X"0d");
        REPORT "Test B passed";

        ----------
        -- Test C - button pulse test
        ----------
        WAIT_until_time(800 us);
        s_test_state   <= TEST_C;
        i_button_press <= '1';
        WAIT UNTIL rising_edge(i_clk);
        ASSERT s_internal_button_press_pulse = '0' REPORT "Button press pulse not detected" SEVERITY FAILURE;
        WAIT UNTIL rising_edge(i_clk);
        ASSERT s_internal_button_press_pulse = '1' REPORT "Button press not pulsed" SEVERITY FAILURE;
        WAIT UNTIL rising_edge(i_clk);
        WAIT FOR 5 us;
        i_button_press <= '0';

        ----------
        -- Test D - write tx char to register
        ----------
        WAIT_until_time(1 ms);
        s_test_state <= TEST_D;
        WAIT;
    END PROCESS;
END ARCHITECTURE;