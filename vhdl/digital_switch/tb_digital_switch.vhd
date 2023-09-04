----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-09-03
-- Design Name:    tb_digital_switch
-- Module Name:    
-- Project Name:   
-- Target Devices: 
-- Tool Versions:  GHDL 4.0.0-dev
-- Description:    
-- Dependencies:   
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_digital_switch is

end tb_digital_switch;

architecture bh of tb_digital_switch is

  component digital_switch is
    port(
        en : in    std_ulogic;
        d1 : inout std_ulogic;
        d2 : inout std_ulogic
    );
  end component;

  constant CLK_PERIOD: TIME := 5 ns;

  signal clk        : std_logic;
  signal rst_n      : std_logic;

  signal lego      : std_logic := 'Z';
  signal bing      : std_logic := 'Z';
  signal sw_en     : std_logic := 'Z';

  signal clk_count  : std_logic_vector(31 downto 0) := (others => '0');
begin

  -- generate clk signal
  p_clk_gen : process
  begin
   clk <= '1';
   wait for (CLK_PERIOD / 2);
   clk <= '0';
   wait for (CLK_PERIOD / 2);
   clk_count <= std_logic_vector(unsigned(clk_count) + 1);
  end process;

  -- generate initial reset
  p_reset_gen : process
  begin 
    rst_n <= '0';
    wait until rising_edge(clk);
    wait for (CLK_PERIOD / 4);
    rst_n <= '1';
    wait;
  end process;

  p_test : process
  begin
    -- initial condition
    wait for (CLK_PERIOD/4);
    assert lego = 'Z' report "lego != Z (0)";
    assert bing = 'Z' report "bing != Z (0)";
    wait for (CLK_PERIOD/4);

    -- set one direction but en not active
    lego <= '0';
    wait for (CLK_PERIOD/4);
    assert bing = 'Z' report "bing != Z (1)";

    -- set en to active
    sw_en <= '0';
    wait for (CLK_PERIOD/4);
    assert bing = '0' report "bing != 0 (2)";

    -- change signal state
    lego <= '1';
    wait for (CLK_PERIOD/4);
    assert bing = '1' report "bing != 1 (3)";

    -- change signal direction
    lego <= 'Z';
    sw_en <= '1';
    wait for (CLK_PERIOD/4);
    assert lego = 'Z' report "lego != Z (4)";

    -- set other signal
    bing <= '0';
    wait for (CLK_PERIOD/4);
    assert lego = '0' report "lego != 0 (5)";

    -- change other signal
    bing <= '1';
    wait for (CLK_PERIOD/4);
    assert lego = '1' report "lego != 1 (6)";

    -- cleanup
    sw_en <= 'Z';

    wait;
  end process;

  sw_inst : digital_switch
    port map (
      en => sw_en,
      d1 => lego,
      d2 => bing
    );

end bh;
