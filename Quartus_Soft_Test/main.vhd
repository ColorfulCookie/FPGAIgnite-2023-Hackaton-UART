library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity main is
  port
  (
    I_clk          : in std_logic;
    I_rx           : in std_logic;
    I_button_press : in std_logic;
    O_tx           : out std_logic
  );
end entity main;

architecture rtl of main is
  component uartus is
    port
    (
      clk                      : in std_logic                     := '1'; --clock
      rst                      : in std_logic                     := '0'; --reset is high active
      tx_data_out              : out std_logic                    := '1'; --transmission bit output (Tx) (continuous 1 for 'off')
      tx_ready                 : out std_logic                    := '0'; -- port for signaling begin ready to transmit a new data word
      tx_data_word_in          : in std_logic_vector(7 downto 0)  := (others => '1'); --transmission word (Tx) (continuous 1 for 'off')
      tx_start                 : in std_logic                     := '0'; -- signal to start transmission
      rx_data_in               : in std_logic                     := '1'; --receiving bit (Rx) (continuous 1 for 'off')
      rx_finished_out          : out std_logic                    := '0'; --port for signaling having finished receiving a data word
      rx_data_word_out         : out std_logic_vector(7 downto 0) := (others => '1'); --tx data word output
      cfg_parity_setting       : in std_logic_vector(1 downto 0)  := "00"; -- 00 -> parity off, 01-> parity even, 10-> parity odd
      cfg_clkSpeed_over_bdRate : in std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(87, 32)) -- sets the effective baudrate; clk/bd, e.g. for a 10MHz clk and with 115.2k Bd: 10 000 000 / 115 200 = 86.8
      -- bits_per_word: integer := 8;--nr of data bits in each transmission; hardcoded to 8 
    );
  end component uartus;

  component test_ram is
    port
    (
      address : in std_logic_vector (7 downto 0);
      clock   : in std_logic := '1';
      data    : in std_logic_vector (7 downto 0);
      wren    : in std_logic;
      q       : out std_logic_vector (7 downto 0)
    );
  end component test_ram;
begin
  uut : uartus
  port map
  (
    clk                      => I_clk,
    rst                      => '0',
    tx_data_out              => O_tx,
    tx_ready                 => open,
    tx_data_word_in => (others => '1'),
    tx_start                 => '0',
    rx_data_in               => I_rx,
    rx_finished_out          => open,
    rx_data_word_out         => open,
    cfg_parity_setting       => "00",
    cfg_clkSpeed_over_bdRate => std_logic_vector(to_unsigned(87, 32))
  );

end architecture;