----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-09-03
-- Design Name:    tb_mux_74xx153
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

entity tb_mux_74xx153 is

end tb_mux_74xx153;

architecture bh of tb_mux_74xx153 is

  component mux_74xx153 is
    port(
      s    : in  std_ulogic_vector(1 downto 0);
      e1_n : in  std_ulogic;
      e2_n : in  std_ulogic;
      i1   : in  std_ulogic_vector(3 downto 0);
      i2   : in  std_ulogic_vector(3 downto 0);
      y1   : out std_ulogic;
      y2   : out std_ulogic
    );
  end component;

  constant CLK_PERIOD: TIME := 5 ns;

  signal clk        : std_logic;
  signal rst_n      : std_logic;

  signal selector : std_ulogic_vector(1 downto 0) := (others => 'Z');
  signal i0      : std_ulogic_vector(3 downto 0) := (others => 'Z');
  signal i1      : std_ulogic_vector(3 downto 0) := (others => 'Z');
  signal o_y1     : std_ulogic := 'Z';
  signal o_y2     : std_ulogic := 'Z';

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
    i0 <= "1010";
    i1 <= "0101";
    wait for (CLK_PERIOD/4);

    -- select channel 0
    selector <= "00";
    wait for (CLK_PERIOD/4);
    assert o_y1 = '0' report "o_y1 != i0 (0)";
    assert o_y2 = '1' report "o_y2 != i0 (0)";

    -- select channel 1
    selector <= "01";
    wait for (CLK_PERIOD/4);
    assert o_y1 = '1' report "o_y1 != i0 (1)";
    assert o_y2 = '0' report "o_y2 != i0 (1)";

    -- select channel 2
    selector <= "10";
    wait for (CLK_PERIOD/4);
    assert o_y1 = '0' report "o_y1 != i0 (2)";
    assert o_y2 = '1' report "o_y2 != i0 (2)";

    -- select channel 3
    selector <= "11";
    wait for (CLK_PERIOD/4);
    assert o_y1 = '1' report "o_y1 != i0 (3)";
    assert o_y2 = '0' report "o_y2 != i0 (3)";


    wait;
  end process;

  sw_inst : mux_74xx153
    port map (
      s    => selector,
      e1_n => '0',
      e2_n => '0',
      i1   => i0,
      i2   => i1,
      y1   => o_y1,
      y2   => o_y2
    );

end bh;
