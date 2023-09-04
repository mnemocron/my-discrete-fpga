----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-09-03
-- Design Name:    tb_mux_74xx151
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

entity tb_mux_74xx151 is

end tb_mux_74xx151;

architecture bh of tb_mux_74xx151 is

  component mux_74xx151 is
    port(
      s    : in  std_ulogic_vector(2 downto 0);
      e_n  : in  std_ulogic;
      i    : in  std_ulogic_vector(7 downto 0);
      y    : out std_ulogic
    );
  end component;

  constant CLK_PERIOD: TIME := 5 ns;

  signal clk        : std_logic;
  signal rst_n      : std_logic;

  signal selector : std_ulogic_vector(2 downto 0) := (others => 'Z');
  signal ins      : std_ulogic_vector(7 downto 0) := (others => 'Z');
  signal o_out    : std_ulogic := 'Z';

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
    ins <= "10101010";
    wait for (CLK_PERIOD/4);

    -- select channel 0
    selector <= "000";
    wait for (CLK_PERIOD/4);
    assert o_out = '0' report "o_out != ins (0)";

    -- select channel 1
    selector <= "001";
    wait for (CLK_PERIOD/4);
    assert o_out = '1' report "o_out != ins (1)";

    -- select channel 2
    selector <= "010";
    wait for (CLK_PERIOD/4);
    assert o_out = '0' report "o_out != ins (2)";

    -- select channel 3
    selector <= "011";
    wait for (CLK_PERIOD/4);
    assert o_out = '1' report "o_out != ins (3)";

    -- select channel 4
    selector <= "100";
    wait for (CLK_PERIOD/4);
    assert o_out = '0' report "o_out != ins (4)";

    -- select channel 5
    selector <= "101";
    wait for (CLK_PERIOD/4);
    assert o_out = '1' report "o_out != ins (5)";

    -- select channel 6
    selector <= "110";
    wait for (CLK_PERIOD/4);
    assert o_out = '0' report "o_out != ins (6)";

    -- select channel 7
    selector <= "111";
    wait for (CLK_PERIOD/4);
    assert o_out = '1' report "o_out != ins (7)";

    wait;
  end process;

  sw_inst : mux_74xx151
    port map (
      s    => selector, 
      e_n  => '0', 
      i    => ins, 
      y    => o_out
    );

end bh;
