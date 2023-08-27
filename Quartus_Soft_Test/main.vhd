LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY main IS
    PORT (
        I_clk          : IN  STD_LOGIC;
        I_rx           : IN  STD_LOGIC;
        I_button_press : IN  STD_LOGIC;
        O_tx           : OUT STD_LOGIC
    );
END ENTITY main;

ARCHITECTURE rtl OF main IS
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

    COMPONENT test_ram IS
        PORT (
            address : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
            clock   : IN  STD_LOGIC := '1';
            data    : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
            wren    : IN  STD_LOGIC;
            q       : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
        );
    END COMPONENT test_ram;
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

    SIGNAL s_rx_data_word_out : STD_LOGIC_VECTOR(7 DOWNTO 0);

    SIGNAL s_tx_ready        : STD_LOGIC := '0';
    SIGNAL s_rx_finished_out : STD_LOGIC := '1';

BEGIN
    uut : uartus
    PORT MAP
    (
        I_clk                      => I_clk,
        I_rst                      => '0',
        O_tx_data                  => O_tx,
        O_tx_ready                 => s_tx_ready,
        I_tx_data_word             => OPEN,
        I_tx_start                 => OPEN,
        I_rx_data                  => I_rx,
        O_rx_finished              => s_rx_finished_out,
        O_rx_data_word             => s_rx_data_word_out,
        I_cfg_parity_setting       => "00",
        I_cfg_clkSpeed_over_bdRate => STD_LOGIC_VECTOR(to_unsigned(87, 32))
    );

END ARCHITECTURE;