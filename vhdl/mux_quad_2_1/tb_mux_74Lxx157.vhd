----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-09-03
-- Design Name:    tb_mux_74Lxx157
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

entity tb_mux_74Lxx157 is

end tb_mux_74Lxx157;

architecture bh of tb_mux_74Lxx157 is

  component mux_74Lxx157 is
    port(
      s    : in  std_ulogic;
      e_n  : in  std_ulogic;
      in_0 : in  std_ulogic_vector(3 downto 0);
      in_1 : in  std_ulogic_vector(3 downto 0);
      y    : out std_ulogic_vector(3 downto 0)
    );
  end component;

  constant CLK_PERIOD: TIME := 5 ns;

  signal clk        : std_logic;
  signal rst_n      : std_logic;

  signal selector : std_logic := 'Z';
  signal i_ch_a   : std_ulogic_vector(3 downto 0) := (others => 'Z');
  signal i_ch_b   : std_ulogic_vector(3 downto 0) := (others => 'Z');
  signal o_out    : std_ulogic_vector(3 downto 0) := (others => 'Z');

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
    i_ch_a <= x"A";
    i_ch_b <= x"B";
    wait for (CLK_PERIOD/4);
    assert o_out = x"A" report "o_out != i_ch_0 (0)";

    -- switch input
    selector <= '1';
    wait for (CLK_PERIOD/4);
    assert o_out = x"B" report "o_out != i_ch_b (2)";

    wait;
  end process;

  sw_inst : mux_74Lxx157
    port map (
      s    => selector,
      e_n  => '0',
      in_0 => i_ch_a,
      in_1 => i_ch_b,
      y    => o_out
    );

end bh;
