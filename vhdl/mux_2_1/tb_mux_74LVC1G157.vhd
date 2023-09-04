----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-09-03
-- Design Name:    tb_mux_74LVC1G157
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

entity tb_mux_74LVC1G157 is

end tb_mux_74LVC1G157;

architecture bh of tb_mux_74LVC1G157 is

  component mux_74LVC1G157 is
    port(
        s   : in  std_ulogic;
        e_n : in  std_ulogic;
        i0  : in  std_ulogic;
        i1  : in  std_ulogic;
        y   : out std_ulogic
    );
  end component;

  constant CLK_PERIOD: TIME := 5 ns;

  signal clk        : std_logic;
  signal rst_n      : std_logic;

  signal selector : std_logic := 'Z';
  signal i_a   : std_logic := 'Z';
  signal i_b   : std_logic := 'Z';
  signal o_out : std_logic := 'Z';

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
    selector <= '0';

    -- set channel A
    i_a <= '0';
    wait for (CLK_PERIOD/4);
    assert o_out = '0' report "o_out != i_a (0)";

    -- toggle
    i_a <= '1';
    wait for (CLK_PERIOD/4);
    assert o_out = '1' report "o_out != i_a (1)";

    -- switch input
    selector <= '1';
    wait for (CLK_PERIOD/4);
    assert o_out = 'Z' report "o_out != i_b (2)";

    -- set channel B
    i_b <= '0';
    wait for (CLK_PERIOD/4);
    assert o_out = '0' report "o_out != i_b (3)";

    -- toggle
    i_b <= '1';
    wait for (CLK_PERIOD/4);
    assert o_out = '1' report "o_out != i_b (4)";

    wait;
  end process;

  sw_inst : mux_74LVC1G157
    port map (
      s   => selector,
      e_n => '0',
      i0  => i_a,
      i1  => i_b,
      y   => o_out
    );

end bh;
