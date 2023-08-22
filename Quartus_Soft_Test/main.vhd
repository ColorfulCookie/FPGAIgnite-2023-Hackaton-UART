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

  type state_type is (IDLE, PRE_TRANSMIT, TRANSMIT, POST_TRANSMIT, PRE_RECEIVE, RECEIVE, POST_RECEIVE);
  signal s_global_state     : state_type             := idle;
  signal s_rw_address       : integer range 0 to 255 := 0;
  signal s_wren             : std_logic              := '0';
  signal s_ram_out          : std_logic_vector(7 downto 0);
  signal s_rx_data_word_out : std_logic_vector(7 downto 0);

  type s_button_edge_state_type is (HIGH, LOW, FALLING, RISING);
  signal s_button_edge_state : s_button_edge_state_type := HIGH;
  signal s_button_edge_pulse : std_logic                := '0';

  signal s_tx_start : std_logic := '0';

begin
  uut : uartus
  port map
  (
    clk                      => I_clk,
    rst                      => '0',
    tx_data_out              => O_tx,
    tx_ready                 => open,
    tx_data_word_in          => s_ram_out,
    tx_start                 => s_tx_start,
    rx_data_in               => I_rx,
    rx_finished_out          => open,
    rx_data_word_out         => s_rx_data_word_out,
    cfg_parity_setting       => "00",
    cfg_clkSpeed_over_bdRate => std_logic_vector(to_unsigned(87, 32))
  );

  test_ram_instance : test_ram
  port
  map
  (
  address => std_logic_vector(to_unsigned(s_rw_address, 8)),
  clock   => I_clk,
  data    => s_rx_data_word_out,
  wren    => s_wren,
  q       => s_ram_out
  );

  s_global_state_process : process (I_clk)
  begin
    if rising_edge(I_clk) then
      case s_global_state is
        when IDLE =>
          if s_button_edge_pulse = '1' then
            s_global_state <= PRE_TRANSMIT;
          end if;
        when PRE_TRANSMIT =>
          s_global_state <= TRANSMIT;
        when TRANSMIT =>
          s_global_state <= POST_TRANSMIT;
        when POST_TRANSMIT =>
          s_global_state <= PRE_RECEIVE;
        when PRE_RECEIVE =>
          s_global_state <= RECEIVE;
        when RECEIVE =>
          s_global_state <= POST_RECEIVE;
        when POST_RECEIVE =>
          s_global_state <= IDLE;
        when others =>
          s_global_state <= IDLE;
      end case;
    end if;
  end process s_global_state_process;

  s_wren_process : process (all)
  begin
    case s_global_state is
      when IDLE =>
        s_wren <= '1';
      when PRE_TRANSMIT =>
        s_wren <= '0';
      when TRANSMIT =>
        s_wren <= '0';
      when POST_TRANSMIT =>
        s_wren <= '0';
      when PRE_RECEIVE =>
        s_wren <= '1';
      when RECEIVE =>
        s_wren <= '1';
      when POST_RECEIVE =>
        s_wren <= '1';
      when others =>
        s_wren <= '0';
    end case;
  end process s_wren_process;
  s_button_edge_state_process : process (I_clk)
  begin
    if rising_edge(I_clk) then
      case s_button_edge_state is
        when LOW =>
          if I_button_press = '1' then
            s_button_edge_state <= RISING;
          end if;
        when HIGH =>
          if I_button_press = '0' then
            s_button_edge_state <= FALLING;
          end if;
        when FALLING =>
          s_button_edge_state <= LOW;
        when RISING =>
          s_button_edge_state <= HIGH;
        when others =>
          s_button_edge_state <= LOW;
      end case;
    end if;
  end process;

  s_button_edge_pulse_process : process (I_clk)
  begin
    case s_button_edge_state is
      when LOW =>
        s_button_edge_pulse <= '0';
      when HIGH =>
        s_button_edge_pulse <= '0';
      when RISING =>
        s_button_edge_pulse <= '1';
      when FALLING =>
        s_button_edge_pulse <= '0';
      when others =>
        s_button_edge_pulse <= '0';
    end case;
  end process;

  s_tx_start_process : process (all)
  begin
    if s_button_edge_pulse = '1' then
      s_tx_start <= '1';
    else
      s_tx_start <= '0';
    end if;
  end process;

  s_rw_address_process : process (I_clk)
  begin
    if rising_edge(I_clk) then
      if s_global_state = POST_RECEIVE then
        s_rw_address <= s_rw_address + 1;
      elsif s_ram_out = x"0d" then
        s_rw_address <= 0;
      else
        s_rw_address <= s_rw_address;
      end if;
    end if;
  end process;

end architecture;