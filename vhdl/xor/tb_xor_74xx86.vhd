----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-09-03
-- Design Name:    tb_xor_74xx86
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

entity tb_xor_74xx86 is

end tb_xor_74xx86;

architecture bh of tb_xor_74xx86 is

  component xor_74xx86 is
    port(
      a : in  std_ulogic_vector(3 downto 0);
      b : in  std_ulogic_vector(3 downto 0);  
      y : out std_ulogic_vector(3 downto 0)
    );
  end component;

  constant CLK_PERIOD: TIME := 5 ns;

  signal clk        : std_logic;
  signal rst_n      : std_logic;

  signal in_0 : std_ulogic_vector(3 downto 0) := (others => 'Z');
  signal in_1 : std_ulogic_vector(3 downto 0) := (others => 'Z');
  signal o_y  : std_ulogic_vector(3 downto 0) := (others => 'Z');

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
    -- set channel A
    in_0 <= "1100";
    in_1 <= "1010";
    wait for (CLK_PERIOD/4);
    assert o_y = "0110" report "o_y not xor function (0)";

    wait;
  end process;

  sw_inst : xor_74xx86
    port map (
      a => in_0,
      b => in_1,
      y => o_y
    );

end bh;
