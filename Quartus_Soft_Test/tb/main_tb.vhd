LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY main_tb IS
    PORT (
        I_clk          : IN  STD_LOGIC;
        I_button_press : IN  STD_LOGIC;
        I_rx           : IN  STD_LOGIC;
        O_tx           : OUT STD_LOGIC

    );
END ENTITY main_tb;

ARCHITECTURE rtl OF main_tb IS
    --
    -- Components
    --
    COMPONENT main IS
        PORT (
            I_clk          : IN  STD_LOGIC;
            I_rx           : IN  STD_LOGIC;
            I_button_press : IN  STD_LOGIC;
            O_tx           : OUT STD_LOGIC
        );
    END COMPONENT main;

    -- 
    -- Signals
    -- 

    CONSTANT c_bit_period : TIME      := ((10000000/115200) * 100 ns); -- 115.2k Bd
    CONSTANT c_clk_period : TIME      := 100 ns;
    SIGNAL s_button_press : STD_LOGIC := '1';
    SIGNAL s_rx           : STD_LOGIC := '1';
    SIGNAL s_clk          : STD_LOGIC := '0';
    SIGNAL s_tx           : STD_LOGIC := '1';

    --
    -- Procedures
    --

    PROCEDURE send_uart_data(s_rx_test_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0); SIGNAL s_rx_data : OUT STD_LOGIC) IS
    BEGIN
        s_rx_data <= '0'; --starting bit
        WAIT FOR c_bit_period;
        FOR i IN 0 TO 7 LOOP --data word
            s_rx_data <= s_rx_test_data(i);
            WAIT FOR c_bit_period;
        END LOOP;
        s_rx_data <= '1'; --end bit
        WAIT FOR c_bit_period;
    END PROCEDURE;

BEGIN
    s_clk <= NOT s_clk AFTER c_clk_period/2;
    uut : main
    PORT MAP
    (
        I_clk          => s_clk,
        I_rx           => s_rx,
        I_button_press => s_button_press,
        O_tx           => s_tx
    );

    PROCESS BEGIN
        WAIT FOR 20 us;
        send_uart_data(x"AA", s_rx);
        WAIT FOR c_bit_period * 50;
        send_uart_data(x"0d", s_rx);
        -- WAIT FOR c_bit_period * 2;
        -- send_uart_data(x"0d", s_rx);
        WAIT FOR 20 us;
        s_button_press <= '0';
        WAIT FOR 200 us;
        s_button_press <= '1';
        WAIT;

    END PROCESS;
END ARCHITECTURE;