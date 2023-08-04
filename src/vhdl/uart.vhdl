library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart is
    port (
        clk                      : in std_logic                     := '1';--clock
        rst                      : in std_logic                     := '0';--reset is high active
        tx_data                  : out std_logic                    := '1'; --transmission bit (TxD) (continuous 1 for 'off')
        rx_data                  : in std_logic                     := '1'; --receiving bit (RxD) (continuous 1 for 'off')
        cfg_parity               : in std_logic                     := '0'; --configure if a parity bit should be used or not; 0-> no; 1->yes
        cfg_clkSpeed_over_bdRate : in std_logic_vector(32 downto 0) :=      -- sets the effective baudrate; clk/bd, e.g. for a 10MHz clk and with 115.2k Bd: 10 000 000 / 115 200 = 86.8
        -- bits_per_msg: integer := 8;--nr of data bits in each transmission; hardcoded to 8 
    );
end entity uart;

architecture behav of uart is
    component uart_clock IS
    GENERIC (
        g_clk_freq : INTEGER := 12_000_000;
        g_baud_rate : INTEGER := 115_200
    );
    PORT (
        I_clk : IN STD_LOGIC;
        I_reset : IN STD_LOGIC;
        O_clk : OUT STD_LOGIC
    );
    END Component uart_clock;

    --constant design variables
    constant bits_per_msg            : integer range(0 to 8) := 8;
    --design variables
    variable sampling_delay          : std_logic_vector(32 downto 0);
    --rx signals
    signal rx_reg                    : std_logic_vector((bits_per_msg - 1) downto 0)             := (others => '1');
    --tx signals
    signal tx_reg                    : std_logic_vector((bits_per_msg + stop_bits + 1) downto 0) := (others => '1');--shifter register: bits/message + nr of stop bits + parity

    --variable signals
    signal start_half_sampling_delay : std_logic                                                 := '0';--signal for starting to wait to sample rx signals at the middle of each signal
    signal start_full_sampling_delay : std_logic                                                 := '0';--signal for starting to wait to sample the next rx signal

    signal counter_tx_time           : unsigned((bits_per_msg + 1) downto 0)                     := (others => '0');--counter for bit transmission time

begin
    sampling_delay := cfg_clkSpeed_over_bdRate;
end architecture;