----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-09-03
-- Design Name:    tb_ff_74xx175
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

entity tb_ff_74xx175 is

end tb_ff_74xx175;

architecture bh of tb_ff_74xx175 is

  component ff_74xx175 is
    port(
      clk    : in  std_ulogic;
      rst_n  : in  std_ulogic;
      din    : in  std_ulogic_vector(7 downto 0);
      qout   : out std_ulogic_vector(7 downto 0);
      qout_n : out std_ulogic_vector(7 downto 0)
    );
  end component;

  constant CLK_PERIOD: TIME := 5 ns;

  signal clk        : std_logic;
  signal rst_n      : std_logic;

  signal tx   : std_ulogic_vector(7 downto 0) := (others => 'Z');
  signal rx   : std_ulogic_vector(7 downto 0) := (others => 'Z');
  signal rx_n : std_ulogic_vector(7 downto 0) := (others => 'Z');

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

  p_test : process(clk)
  begin
    if rising_edge(clk) then
      if unsigned(clk_count) = 1 then
        tx <= x"00";
      end if;
      if unsigned(clk_count) = 5 then
        tx <= x"A5";
      end if;
      if unsigned(clk_count) = 6 then
        tx <= x"5A";
      end if;
      if unsigned(clk_count) = 10 then
        tx <= x"00";
      end if;
    end if;
  end process;

  p_assert : process(clk)
  begin
    if rising_edge(clk) then
      if unsigned(clk_count) = 5 then
        assert rx = x"00" report "rx != tx (0)";
      end if;
      if unsigned(clk_count) = 7 then
        assert rx = x"A5" report "rx != tx (1)";
      end if;
      if unsigned(clk_count) = 8 then
        assert rx = x"5A" report "rx != tx (2)";
      end if;
      if unsigned(clk_count) = 12 then
        assert rx = x"00" report "rx != tx (3)";
      end if;
    end if;
  end process;

  sw_inst : ff_74xx175
    port map (
      clk    => clk,
      rst_n  => rst_n,
      din    => tx,
      qout   => rx,
      qout_n => rx_n
    );

end bh;
