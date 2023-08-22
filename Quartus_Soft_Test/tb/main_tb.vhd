library ieee;
use ieee.std_logic_1164.all;

entity main_tb is
  port
  (
    I_clk          : in std_logic;
    I_button_press : in std_logic;
    I_rx           : in std_logic;
    O_tx           : out std_logic

  );
end entity main_tb;

architecture rtl of main_tb is
  component main is
    port
    (
      I_clk          : in std_logic;
      I_rx           : in std_logic;
      I_button_press : in std_logic;
      O_tx           : out std_logic
    );
  end component main;
begin
  uut : main
  port map
  (
    I_clk          => I_clk,
    I_rx           => I_rx,
    I_button_press => '0',
    O_tx           => open
  );
end architecture;