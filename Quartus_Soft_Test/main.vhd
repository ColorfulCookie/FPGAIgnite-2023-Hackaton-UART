LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY main IS
    GENERIC (
        g_cfg_clkSpeed_over_bdRate : STD_LOGIC_VECTOR(31 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(87, 32)) -- sets the effective baudrate; clk/bd, e.g. for a 10MHz clk and with 115.2k Bd: 10 000 000 / 115 200 = 86.8
    );
    PORT (
        I_clk          : IN  STD_LOGIC;
        I_rx           : IN  STD_LOGIC;
        I_button_press : IN  STD_LOGIC;
        O_tx           : OUT STD_LOGIC
    );
END ENTITY main;

ARCHITECTURE rtl OF main IS
    -------------
    -- Components
    -------------
    COMPONENT uartus IS
        PORT (
            I_clk                      : IN  STD_LOGIC                     := '1'; --clock
            I_rst                      : IN  STD_LOGIC                     := '0'; --reset is high active
            O_tx_data                  : OUT STD_LOGIC                    := '1'; --transmission bit output (Tx) (continuous 1 for 'off')
            O_tx_ready                 : OUT STD_LOGIC                    := '0'; -- port for signaling begin ready to transmit a new data word
            I_tx_data_word             : IN  STD_LOGIC_VECTOR(7 DOWNTO 0)  := (OTHERS => '1'); --transmission word (Tx) (continuous 1 for 'off')
            I_tx_start                 : IN  STD_LOGIC                     := '0'; -- signal to start transmission
            I_rx_data                  : IN  STD_LOGIC                     := '1'; --receiving bit (Rx) (continuous 1 for 'off')
            O_rx_finished              : OUT STD_LOGIC                    := '0'; --port for signaling having finished receiving a data word
            O_rx_data_word             : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '1'); --tx data word output
            I_cfg_parity_setting       : IN  STD_LOGIC_VECTOR(1 DOWNTO 0)  := "00"; -- 00 -> parity off, 01-> parity even, 10-> parity odd
            I_cfg_clkSpeed_over_bdRate : IN  STD_LOGIC_VECTOR(31 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(87, 32)) -- sets the effective baudrate; clk/bd, e.g. for a 10MHz clk and with 115.2k Bd: 10 000 000 / 115 200 = 86.8
            -- bits_per_word: integer := 8;--nr of data bits in each transmission; hardcoded to 8 
        );
    END COMPONENT uartus;

    COMPONENT edge_detector IS
        GENERIC (
            g_rising  : STD_LOGIC := '1';
            g_falling : STD_LOGIC := '0'
        );
        PORT (
            clk          : IN  STD_LOGIC;
            I_signal     : IN  STD_LOGIC;
            O_edge_pulse : OUT STD_LOGIC
        );
    END COMPONENT edge_detector;

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

    ----------
    -- Signals
    ----------

    TYPE t_tx_state IS (
        tx_idle,
        tx_start,
        tx_post
    );
    SIGNAL s_tx_state : t_tx_state := tx_idle;

    SIGNAL s_clk                      : STD_LOGIC;
    SIGNAL s_rst                      : STD_LOGIC;
    SIGNAL s_tx_data                  : STD_LOGIC;
    SIGNAL s_tx_ready                 : STD_LOGIC;
    SIGNAL s_tx_ready_pulse           : STD_LOGIC;
    SIGNAL s_tx_data_word             : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL s_tx_start                 : STD_LOGIC;
    SIGNAL s_tx_start_pulse           : STD_LOGIC;
    SIGNAL s_rx_finished              : STD_LOGIC;
    SIGNAL s_rx_finished_pulse        : STD_LOGIC;
    SIGNAL s_rx_data_word             : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL s_cfg_parity_setting       : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL s_cfg_clkSpeed_over_bdRate : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL s_button_press_pulse : STD_LOGIC := '0';
    SIGNAL s_reg_out            : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
    s_cfg_clkSpeed_over_bdRate <= g_cfg_clkSpeed_over_bdRate;
    uart_module : uartus
    PORT MAP(
        I_clk                      => I_clk,
        I_rst                      => '0',
        O_tx_data                  => s_tx_data,
        O_tx_ready                 => s_tx_ready,
        I_tx_data_word             => s_reg_out,
        I_tx_start                 => s_tx_start_pulse,
        I_rx_data                  => I_rx,
        O_rx_finished              => s_rx_finished,
        O_rx_data_word             => s_rx_data_word,
        I_cfg_parity_setting       => s_cfg_parity_setting,
        I_cfg_clkSpeed_over_bdRate => g_cfg_clkSpeed_over_bdRate
    );

    button_edge_detector : edge_detector
    GENERIC MAP(
        g_rising  => '1',
        g_falling => '0'
    )
    PORT MAP(
        clk          => I_clk,
        I_signal     => I_button_press,
        O_edge_pulse => s_button_press_pulse
    );
    rx_finished_detector : edge_detector
    GENERIC MAP(
        g_rising  => '1',
        g_falling => '0'
    )
    PORT MAP(
        clk          => I_clk,
        I_signal     => s_rx_finished,
        O_edge_pulse => s_rx_finished_pulse
    );
    tx_ready_edge_detector : edge_detector
    GENERIC MAP(
        g_rising  => '1',
        g_falling => '0'
    )
    PORT MAP(
        clk          => I_clk,
        I_signal     => s_tx_ready,
        O_edge_pulse => s_tx_ready_pulse
    );

    register_file_module : register_file
    GENERIC MAP(
        g_register_count => 32
    )
    PORT MAP(
        i_clk             => I_clk,
        i_reset           => '0',
        i_increment_pulse => s_rx_finished_pulse OR s_tx_ready_pulse,
        i_write_enable    => s_rx_finished_pulse,
        i_word_in         => s_rx_data_word,
        o_word_out        => s_reg_out
    );

    tx_state_machine : PROCESS (I_clk)
    BEGIN
        IF rising_edge(I_clk) THEN
            CASE s_tx_state IS
                WHEN tx_idle =>
                    IF s_button_press_pulse = '1' THEN
                        s_tx_state <= tx_start;
                    END IF;
                WHEN tx_start =>
                    IF s_tx_ready_pulse = '1' THEN
                        s_tx_state <= tx_post;
                    ELSE
                        s_tx_state <= tx_start;
                    END IF;
                WHEN tx_post =>
                    IF s_reg_out = x"0d" THEN
                        s_tx_state <= tx_idle;
                    ELSE
                        s_tx_state <= tx_start;
                    END IF;
                WHEN OTHERS =>
                    s_tx_state <= tx_idle;
            END CASE;
        END IF;
    END PROCESS tx_state_machine;

    s_tx_start_process : PROCESS (I_clk)
    BEGIN
        IF rising_edge(I_clk) THEN
            IF s_tx_state = tx_start THEN
                s_tx_start_pulse <= '1';
            ELSE
                s_tx_start_pulse <= '0';
            END IF;
        END IF;
    END PROCESS s_tx_start_process;

END ARCHITECTURE;