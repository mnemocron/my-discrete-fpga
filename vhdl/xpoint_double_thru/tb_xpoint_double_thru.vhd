----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-09-07
-- Design Name:    tb_xpoint_double_thru
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

entity tb_xpoint_double_thru is

end tb_xpoint_double_thru;

architecture bh of tb_xpoint_double_thru is

  component xpoint_double_thru is
    port(
      d_n  : inout std_logic_vector(1 downto 0);
      d_s  : inout std_logic_vector(1 downto 0);
      d_e  : inout std_logic_vector(1 downto 0);
      d_w  : inout std_logic_vector(1 downto 0);
      x_ne : in    std_logic;
      x_nw : in    std_logic;
      x_se : in    std_logic;
      x_sw : in    std_logic;
      en_n : in    std_logic_vector(1 downto 0);
      en_s : in    std_logic_vector(1 downto 0);
      en_e : in    std_logic_vector(1 downto 0);
      en_w : in    std_logic_vector(1 downto 0)
    );
  end component;

  constant CLK_PERIOD: TIME := 10 ns;

  signal clk        : std_logic;
  signal rst_n      : std_logic;

  signal sw_16,sw_17,sw_18,sw_19 : std_logic := '0';
  signal sw_20,sw_21,sw_22,sw_23 : std_logic := '0';
  signal sw_24,sw_25,sw_26,sw_27 : std_logic := '0';
  signal sw_28,sw_29,sw_30,sw_31 : std_logic := '0';
  signal x_4,x_5,x_6,x_7         : std_logic := '0';

  signal en_n : std_logic_vector(1 downto 0);
  signal en_s : std_logic_vector(1 downto 0);
  signal en_e : std_logic_vector(1 downto 0);
  signal en_w : std_logic_vector(1 downto 0);

  signal bus_n : std_logic_vector(1 downto 0) := (others => 'Z');
  signal bus_s : std_logic_vector(1 downto 0) := (others => 'Z');
  signal bus_e : std_logic_vector(1 downto 0) := (others => 'Z');
  signal bus_w : std_logic_vector(1 downto 0) := (others => 'Z');

  signal clk_count  : std_logic_vector(31 downto 0) := (others => '0');

  signal clear : std_logic := '0';
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

  --p_set_initial : process(clear)
  --begin
  --  if rising_edge(clear) then
  --    sw_16 <= '0';
  --    sw_17 <= '0';
  --    sw_18 <= '0';
  --    sw_19 <= '0';
  --    sw_20 <= '0';
  --    sw_21 <= '0';
  --    sw_22 <= '0';
  --    sw_23 <= '0';
  --    sw_24 <= '0';
  --    sw_25 <= '0';
  --    sw_26 <= '0';
  --    sw_27 <= '0';
  --    sw_28 <= '0';
  --    sw_29 <= '0';
  --    sw_30 <= '0';
  --    sw_31 <= '0';
  --    x_4   <= '0';
  --    x_5   <= '0';
  --    x_6   <= '0';
  --    x_7   <= '0';
  --    bus_n <= (others => 'Z');
  --    bus_s <= (others => 'Z');
  --    bus_e <= (others => 'Z');
  --    bus_w <= (others => 'Z');
  --  end if;
  --end process;

  en_n(0) <= sw_26;
  en_n(1) <= sw_27;
  en_s(0) <= sw_24;
  en_s(1) <= sw_25;
  en_e(0) <= sw_30;
  en_e(1) <= sw_31;
  en_w(0) <= sw_28;
  en_w(1) <= sw_29;

  p_test : process
  begin
    -- initial condition
    wait for (CLK_PERIOD);

    ----------------------------------------------------------------------------
    report "SOUTH(1) to WEST(1)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    x_7   <= '1';
    sw_25 <= '1';
    sw_29 <= '1';
    wait for (CLK_PERIOD);
    bus_s(1) <= '0';
    wait for (CLK_PERIOD);
    assert bus_w(1)  = bus_s(1) report "W(1) does not match S(1)";
    assert bus_w(0) /= bus_s(1) report "W(0) is active";
    assert bus_e(0) /= bus_s(1) report "E(0) is active";
    assert bus_e(1) /= bus_s(1) report "E(1) is active";
    assert bus_n(0) /= bus_s(1) report "N(0) is active";
    assert bus_n(1) /= bus_s(1) report "N(1) is active";
    bus_s(1) <= '1';
    wait for (CLK_PERIOD);
    assert bus_w(1)  = bus_s(1) report "W(1) does not match S(1)";
    assert bus_w(0) /= bus_s(1) report "W(0) is active";
    assert bus_e(0) /= bus_s(1) report "E(0) is active";
    assert bus_e(1) /= bus_s(1) report "E(1) is active";
    assert bus_n(0) /= bus_s(1) report "N(0) is active";
    assert bus_n(1) /= bus_s(1) report "N(1) is active";
    x_7   <= '0';
    sw_25 <= '0';
    sw_29 <= '0';
    bus_s <= (others => 'Z');
    bus_w <= (others => 'Z');

    report "SOUTH(1) to WEST(0)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    x_5   <= '1';
    sw_25 <= '1';
    sw_28 <= '1';
    wait for (CLK_PERIOD);
    bus_s(1) <= '0';
    wait for (CLK_PERIOD);
    assert bus_w(0)  = bus_s(1) report "W(0) does not match S(1)";
    assert bus_w(1) /= bus_s(1) report "W(1) is active";
    assert bus_e(0) /= bus_s(1) report "E(0) is active";
    assert bus_e(1) /= bus_s(1) report "E(1) is active";
    assert bus_n(0) /= bus_s(1) report "N(0) is active";
    assert bus_n(1) /= bus_s(1) report "N(1) is active";
    bus_s(1) <= '1';
    wait for (CLK_PERIOD);
    assert bus_w(0)  = bus_s(1) report "W(0) does not match S(1)";
    assert bus_w(1) /= bus_s(1) report "W(1) is active";
    assert bus_e(0) /= bus_s(1) report "E(0) is active";
    assert bus_e(1) /= bus_s(1) report "E(1) is active";
    assert bus_n(0) /= bus_s(1) report "N(0) is active";
    assert bus_n(1) /= bus_s(1) report "N(1) is active";
    x_5   <= '0';
    sw_25 <= '0';
    sw_28 <= '0';
    bus_s <= (others => 'Z');
    bus_w <= (others => 'Z');

    report "SOUTH(1) to EAST(1)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    x_7   <= '1';
    sw_25 <= '1';
    sw_31 <= '1';
    wait for (CLK_PERIOD);
    bus_s(1) <= '0';
    wait for (CLK_PERIOD);
    assert bus_e(1)  = bus_s(1) report "E(1) does not match S(1)";
    assert bus_e(0) /= bus_s(1) report "E(0) is active";
    assert bus_w(0) /= bus_s(1) report "W(0) is active";
    assert bus_w(1) /= bus_s(1) report "W(1) is active";
    assert bus_n(0) /= bus_s(1) report "N(0) is active";
    assert bus_n(1) /= bus_s(1) report "N(1) is active";
    bus_s(1) <= '1';
    wait for (CLK_PERIOD);
    assert bus_e(1)  = bus_s(1) report "E(1) does not match S(1)";
    assert bus_e(0) /= bus_s(1) report "E(0) is active";
    assert bus_w(0) /= bus_s(1) report "W(0) is active";
    assert bus_w(1) /= bus_s(1) report "W(1) is active";
    assert bus_n(0) /= bus_s(1) report "N(0) is active";
    assert bus_n(1) /= bus_s(1) report "N(1) is active";
    x_7   <= '0';
    sw_25 <= '0';
    sw_31 <= '0';
    bus_s <= (others => 'Z');
    bus_e <= (others => 'Z');

    report "SOUTH(1) to EAST(0)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    x_5   <= '1';
    sw_25 <= '1';
    sw_30 <= '1';
    wait for (CLK_PERIOD);
    bus_s(1) <= '0';
    wait for (CLK_PERIOD);
    assert bus_e(0)  = bus_s(1) report "E(0) does not match S(1)";
    assert bus_e(1) /= bus_s(1) report "E(1) is active";
    assert bus_w(0) /= bus_s(1) report "E(0) is active";
    assert bus_w(1) /= bus_s(1) report "E(1) is active";
    assert bus_n(0) /= bus_s(1) report "N(0) is active";
    assert bus_n(1) /= bus_s(1) report "N(1) is active";
    bus_s(1) <= '1';
    wait for (CLK_PERIOD);
    assert bus_e(0)  = bus_s(1) report "E(0) does not match S(1)";
    assert bus_e(1) /= bus_s(1) report "E(1) is active";
    assert bus_w(0) /= bus_s(1) report "E(0) is active";
    assert bus_w(1) /= bus_s(1) report "E(1) is active";
    assert bus_n(0) /= bus_s(1) report "N(0) is active";
    assert bus_n(1) /= bus_s(1) report "N(1) is active";
    x_5   <= '0';
    sw_25 <= '0';
    sw_30 <= '0';
    bus_s <= (others => 'Z');
    bus_e <= (others => 'Z');

    report "SOUTH(1) to NORTH(1)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    sw_25 <= '1';
    sw_27 <= '1';
    wait for (CLK_PERIOD);
    bus_s(1) <= '0';
    wait for (CLK_PERIOD);
    assert bus_n(1)  = bus_s(1) report "N(1) does not match S(1)";
    assert bus_n(0) /= bus_s(1) report "N(0) is active";
    assert bus_w(0) /= bus_s(1) report "W(0) is active";
    assert bus_w(1) /= bus_s(1) report "W(1) is active";
    assert bus_e(0) /= bus_s(1) report "E(0) is active";
    assert bus_e(1) /= bus_s(1) report "E(1) is active";
    bus_s(1) <= '1';
    wait for (CLK_PERIOD);
    assert bus_n(1)  = bus_s(1) report "N(1) does not match S(1)";
    assert bus_n(0) /= bus_s(1) report "N(0) is active";
    assert bus_w(0) /= bus_s(1) report "W(0) is active";
    assert bus_w(1) /= bus_s(1) report "W(1) is active";
    assert bus_e(0) /= bus_s(1) report "E(0) is active";
    assert bus_e(1) /= bus_s(1) report "E(1) is active";
    sw_25 <= '0';
    sw_27 <= '0';
    bus_s <= (others => 'Z');
    bus_n <= (others => 'Z');
    ----------------------------------------------------------------------------
    report "SOUTH(0) to WEST(1)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    x_6   <= '1';
    sw_24 <= '1';
    sw_29 <= '1';
    wait for (CLK_PERIOD);
    bus_s(0) <= '0';
    wait for (CLK_PERIOD);
    assert bus_w(1)  = bus_s(0) report "W(1) does not match S(0)";
    assert bus_w(0) /= bus_s(0) report "W(0) is active";
    assert bus_e(0) /= bus_s(0) report "E(0) is active";
    assert bus_e(1) /= bus_s(0) report "E(1) is active";
    assert bus_n(0) /= bus_s(0) report "N(0) is active";
    assert bus_n(1) /= bus_s(0) report "N(1) is active";
    bus_s(0) <= '1';
    wait for (CLK_PERIOD);
    assert bus_w(1)  = bus_s(0) report "W(1) does not match S(0)";
    assert bus_w(0) /= bus_s(0) report "W(0) is active";
    assert bus_e(0) /= bus_s(0) report "E(0) is active";
    assert bus_e(1) /= bus_s(0) report "E(1) is active";
    assert bus_n(0) /= bus_s(0) report "N(0) is active";
    assert bus_n(1) /= bus_s(0) report "N(1) is active";
    x_6   <= '0';
    sw_24 <= '0';
    sw_29 <= '0';
    bus_s <= (others => 'Z');
    bus_w <= (others => 'Z');

    report "SOUTH(0) to WEST(0)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    x_4   <= '1';
    sw_24 <= '1';
    sw_28 <= '1';
    wait for (CLK_PERIOD);
    bus_s(0) <= '0';
    wait for (CLK_PERIOD);
    assert bus_w(0)  = bus_s(0) report "W(0) does not match S(0)";
    assert bus_w(1) /= bus_s(0) report "W(1) is active";
    assert bus_e(0) /= bus_s(0) report "E(0) is active";
    assert bus_e(1) /= bus_s(0) report "E(1) is active";
    assert bus_n(0) /= bus_s(0) report "N(0) is active";
    assert bus_n(1) /= bus_s(0) report "N(1) is active";
    bus_s(0) <= '1';
    wait for (CLK_PERIOD);
    assert bus_w(0)  = bus_s(0) report "W(0) does not match S(0)";
    assert bus_w(1) /= bus_s(0) report "W(1) is active";
    assert bus_e(0) /= bus_s(0) report "E(0) is active";
    assert bus_e(1) /= bus_s(0) report "E(1) is active";
    assert bus_n(0) /= bus_s(0) report "N(0) is active";
    assert bus_n(1) /= bus_s(0) report "N(1) is active";
    x_4   <= '0';
    sw_24 <= '0';
    sw_28 <= '0';
    bus_s <= (others => 'Z');
    bus_w <= (others => 'Z');

    report "SOUTH(0) to EAST(1)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    x_6   <= '1';
    sw_24 <= '1';
    sw_31 <= '1';
    wait for (CLK_PERIOD);
    bus_s(0) <= '0';
    wait for (CLK_PERIOD);
    assert bus_e(1)  = bus_s(0) report "E(1) does not match S(0)";
    assert bus_e(0) /= bus_s(0) report "E(0) is active";
    assert bus_w(0) /= bus_s(0) report "W(0) is active";
    assert bus_w(1) /= bus_s(0) report "W(1) is active";
    assert bus_n(0) /= bus_s(0) report "N(0) is active";
    assert bus_n(1) /= bus_s(0) report "N(1) is active";
    bus_s(0) <= '1';
    wait for (CLK_PERIOD);
    assert bus_e(1)  = bus_s(0) report "E(1) does not match S(0)";
    assert bus_e(0) /= bus_s(0) report "E(0) is active";
    assert bus_w(0) /= bus_s(0) report "W(0) is active";
    assert bus_w(1) /= bus_s(0) report "W(1) is active";
    assert bus_n(0) /= bus_s(0) report "N(0) is active";
    assert bus_n(1) /= bus_s(0) report "N(1) is active";
    x_6   <= '0';
    sw_24 <= '0';
    sw_31 <= '0';
    bus_s <= (others => 'Z');
    bus_e <= (others => 'Z');

    report "SOUTH(0) to EAST(0)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    x_4   <= '1';
    sw_24 <= '1';
    sw_30 <= '1';
    wait for (CLK_PERIOD);
    bus_s(0) <= '0';
    wait for (CLK_PERIOD);
    assert bus_e(0)  = bus_s(0) report "E(0) does not match S(0)";
    assert bus_e(1) /= bus_s(0) report "E(1) is active";
    assert bus_w(0) /= bus_s(0) report "E(0) is active";
    assert bus_w(1) /= bus_s(0) report "E(1) is active";
    assert bus_n(0) /= bus_s(0) report "N(0) is active";
    assert bus_n(1) /= bus_s(0) report "N(1) is active";
    bus_s(0) <= '1';
    wait for (CLK_PERIOD);
    assert bus_e(0)  = bus_s(0) report "E(0) does not match S(0)";
    assert bus_e(1) /= bus_s(0) report "E(1) is active";
    assert bus_w(0) /= bus_s(0) report "E(0) is active";
    assert bus_w(1) /= bus_s(0) report "E(1) is active";
    assert bus_n(0) /= bus_s(0) report "N(0) is active";
    assert bus_n(1) /= bus_s(0) report "N(1) is active";
    x_4   <= '0';
    sw_24 <= '0';
    sw_30 <= '0';
    bus_s <= (others => 'Z');
    bus_e <= (others => 'Z');

    report "SOUTH(0) to NORTH(0)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    sw_24 <= '1';
    sw_26 <= '1';
    wait for (CLK_PERIOD);
    bus_s(0) <= '0';
    wait for (CLK_PERIOD);
    assert bus_n(0)  = bus_s(0) report "N(0) does not match S(0)";
    assert bus_n(1) /= bus_s(0) report "N(1) is active";
    assert bus_w(0) /= bus_s(0) report "W(0) is active";
    assert bus_w(1) /= bus_s(0) report "W(1) is active";
    assert bus_e(0) /= bus_s(0) report "E(0) is active";
    assert bus_e(1) /= bus_s(0) report "E(1) is active";
    bus_s(0) <= '1';
    wait for (CLK_PERIOD);
    assert bus_n(0)  = bus_s(0) report "N(0) does not match S(0)";
    assert bus_n(1) /= bus_s(0) report "N(1) is active";
    assert bus_w(0) /= bus_s(0) report "W(0) is active";
    assert bus_w(1) /= bus_s(0) report "W(1) is active";
    assert bus_e(0) /= bus_s(0) report "E(0) is active";
    assert bus_e(1) /= bus_s(0) report "E(1) is active";
    sw_24 <= '0';
    sw_26 <= '0';
    bus_s <= (others => 'Z');
    bus_n <= (others => 'Z');
    ----------------------------------------------------------------------------
    report "NORTH(1) to WEST(1)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    x_7   <= '1';
    sw_27 <= '1';
    sw_29 <= '1';
    wait for (CLK_PERIOD);
    bus_n(1) <= '0';
    wait for (CLK_PERIOD);
    assert bus_w(1)  = bus_n(1) report "W(1) does not match N(1)";
    assert bus_w(0) /= bus_n(1) report "W(0) is active";
    assert bus_e(0) /= bus_n(1) report "E(0) is active";
    assert bus_e(1) /= bus_n(1) report "E(1) is active";
    assert bus_s(0) /= bus_n(1) report "S(0) is active";
    assert bus_s(1) /= bus_n(1) report "S(1) is active";
    bus_n(1) <= '1';
    wait for (CLK_PERIOD);
    assert bus_w(1)  = bus_n(1) report "W(1) does not match N(1)";
    assert bus_w(0) /= bus_n(1) report "W(0) is active";
    assert bus_e(0) /= bus_n(1) report "E(0) is active";
    assert bus_e(1) /= bus_n(1) report "E(1) is active";
    assert bus_s(0) /= bus_n(1) report "S(0) is active";
    assert bus_s(1) /= bus_n(1) report "S(1) is active";
    x_7   <= '0';
    sw_27 <= '0';
    sw_29 <= '0';
    bus_n <= (others => 'Z');
    bus_w <= (others => 'Z');

    report "NORTH(1) to WEST(0)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    x_5   <= '1';
    sw_27 <= '1';
    sw_28 <= '1';
    wait for (CLK_PERIOD);
    bus_n(1) <= '0';
    wait for (CLK_PERIOD);
    assert bus_w(0)  = bus_n(1) report "W(0) does not match N(1)";
    assert bus_w(1) /= bus_n(1) report "W(1) is active";
    assert bus_e(0) /= bus_n(1) report "E(0) is active";
    assert bus_e(1) /= bus_n(1) report "E(1) is active";
    assert bus_s(0) /= bus_n(1) report "S(0) is active";
    assert bus_s(1) /= bus_n(1) report "S(1) is active";
    bus_n(1) <= '1';
    wait for (CLK_PERIOD);
    assert bus_w(0)  = bus_n(1) report "W(0) does not match N(1)";
    assert bus_w(1) /= bus_n(1) report "W(1) is active";
    assert bus_e(0) /= bus_n(1) report "E(0) is active";
    assert bus_e(1) /= bus_n(1) report "E(1) is active";
    assert bus_s(0) /= bus_n(1) report "S(0) is active";
    assert bus_s(1) /= bus_n(1) report "S(1) is active";
    x_5   <= '0';
    sw_27 <= '0';
    sw_28 <= '0';
    bus_n <= (others => 'Z');
    bus_w <= (others => 'Z');

    report "NORTH(1) to EAST(1)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    x_7   <= '1';
    sw_27 <= '1';
    sw_31 <= '1';
    wait for (CLK_PERIOD);
    bus_n(1) <= '0';
    wait for (CLK_PERIOD);
    assert bus_e(1)  = bus_n(1) report "E(1) does not match N(1)";
    assert bus_e(0) /= bus_n(1) report "E(0) is active";
    assert bus_w(0) /= bus_n(1) report "W(0) is active";
    assert bus_w(1) /= bus_n(1) report "W(1) is active";
    assert bus_s(0) /= bus_n(1) report "S(0) is active";
    assert bus_s(1) /= bus_n(1) report "S(1) is active";
    bus_n(1) <= '1';
    wait for (CLK_PERIOD);
    assert bus_e(1)  = bus_n(1) report "E(1) does not match N(1)";
    assert bus_e(0) /= bus_n(1) report "E(0) is active";
    assert bus_w(0) /= bus_n(1) report "W(0) is active";
    assert bus_w(1) /= bus_n(1) report "W(1) is active";
    assert bus_s(0) /= bus_n(1) report "S(0) is active";
    assert bus_s(1) /= bus_n(1) report "S(1) is active";
    x_7   <= '0';
    sw_27 <= '0';
    sw_31 <= '0';
    bus_n <= (others => 'Z');
    bus_e <= (others => 'Z');

    report "NORTH(1) to EAST(0)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    x_5   <= '1';
    sw_27 <= '1';
    sw_30 <= '1';
    wait for (CLK_PERIOD);
    bus_n(1) <= '0';
    wait for (CLK_PERIOD);
    assert bus_e(0)  = bus_n(1) report "E(0) does not match N(1)";
    assert bus_e(1) /= bus_n(1) report "E(1) is active";
    assert bus_w(0) /= bus_n(1) report "E(0) is active";
    assert bus_w(1) /= bus_n(1) report "E(1) is active";
    assert bus_s(0) /= bus_n(1) report "S(0) is active";
    assert bus_s(1) /= bus_n(1) report "S(1) is active";
    bus_n(1) <= '1';
    wait for (CLK_PERIOD);
    assert bus_e(0)  = bus_n(1) report "E(0) does not match N(1)";
    assert bus_e(1) /= bus_n(1) report "E(1) is active";
    assert bus_w(0) /= bus_n(1) report "E(0) is active";
    assert bus_w(1) /= bus_n(1) report "E(1) is active";
    assert bus_s(0) /= bus_n(1) report "S(0) is active";
    assert bus_s(1) /= bus_n(1) report "S(1) is active";
    x_5   <= '0';
    sw_27 <= '0';
    sw_30 <= '0';
    bus_n <= (others => 'Z');
    bus_e <= (others => 'Z');

    report "NORTH(1) to SOUTH(1)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    sw_27 <= '1';
    sw_25 <= '1';
    wait for (CLK_PERIOD);
    bus_n(1) <= '0';
    wait for (CLK_PERIOD);
    assert bus_s(1)  = bus_n(1) report "S(1) does not match N(1)";
    assert bus_s(0) /= bus_n(1) report "S(0) is active";
    assert bus_w(0) /= bus_n(1) report "W(0) is active";
    assert bus_w(1) /= bus_n(1) report "W(1) is active";
    assert bus_e(0) /= bus_n(1) report "E(0) is active";
    assert bus_e(1) /= bus_n(1) report "E(1) is active";
    bus_n(1) <= '1';
    wait for (CLK_PERIOD);
    assert bus_s(1)  = bus_n(1) report "S(1) does not match N(1)";
    assert bus_s(0) /= bus_n(1) report "S(0) is active";
    assert bus_w(0) /= bus_n(1) report "W(0) is active";
    assert bus_w(1) /= bus_n(1) report "W(1) is active";
    assert bus_e(0) /= bus_n(1) report "E(0) is active";
    assert bus_e(1) /= bus_n(1) report "E(1) is active";
    sw_27 <= '0';
    sw_25 <= '0';
    bus_n <= (others => 'Z');
    bus_s <= (others => 'Z');
    ----------------------------------------------------------------------------
    report "EAST(1) to NORTH(0)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    x_6   <= '1';
    sw_26 <= '1';
    sw_31 <= '1';
    wait for (CLK_PERIOD);
    bus_e(1) <= '0';
    wait for (CLK_PERIOD);
    assert bus_n(0)  = bus_e(1) report "N(0) does not match E(1)";
    assert bus_n(1) /= bus_e(1) report "N(1) is active";
    assert bus_w(0) /= bus_e(1) report "E(0) is active";
    assert bus_w(1) /= bus_e(1) report "E(1) is active";
    assert bus_s(0) /= bus_e(1) report "S(0) is active";
    assert bus_s(1) /= bus_e(1) report "S(1) is active";
    bus_e(1) <= '1';
    wait for (CLK_PERIOD);
    assert bus_n(0)  = bus_e(1) report "N(0) does not match E(1)";
    assert bus_n(1) /= bus_e(1) report "N(1) is active";
    assert bus_w(0) /= bus_e(1) report "E(0) is active";
    assert bus_w(1) /= bus_e(1) report "E(1) is active";
    assert bus_s(0) /= bus_e(1) report "S(0) is active";
    assert bus_s(1) /= bus_e(1) report "S(1) is active";
    x_6   <= '0';
    sw_26 <= '0';
    sw_31 <= '0';
    bus_e <= (others => 'Z');
    bus_n <= (others => 'Z');

    report "EAST(1) to NORTH(1)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    x_7   <= '1';
    sw_27 <= '1';
    sw_31 <= '1';
    wait for (CLK_PERIOD);
    bus_e(1) <= '0';
    wait for (CLK_PERIOD);
    assert bus_n(1)  = bus_e(1) report "N(1) does not match E(1)";
    assert bus_n(0) /= bus_e(1) report "N(0) is active";
    assert bus_w(0) /= bus_e(1) report "E(0) is active";
    assert bus_w(1) /= bus_e(1) report "E(1) is active";
    assert bus_s(0) /= bus_e(1) report "S(0) is active";
    assert bus_s(1) /= bus_e(1) report "S(1) is active";
    bus_e(1) <= '1';
    wait for (CLK_PERIOD);
    assert bus_n(1)  = bus_e(1) report "N(1) does not match E(1)";
    assert bus_n(0) /= bus_e(1) report "N(0) is active";
    assert bus_w(0) /= bus_e(1) report "E(0) is active";
    assert bus_w(1) /= bus_e(1) report "E(1) is active";
    assert bus_s(0) /= bus_e(1) report "S(0) is active";
    assert bus_s(1) /= bus_e(1) report "S(1) is active";
    x_7   <= '0';
    sw_27 <= '0';
    sw_31 <= '0';
    bus_e <= (others => 'Z');
    bus_n <= (others => 'Z');

    report "EAST(1) to SOUTH(0)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    x_6   <= '1';
    sw_24 <= '1';
    sw_31 <= '1';
    wait for (CLK_PERIOD);
    bus_e(1) <= '0';
    wait for (CLK_PERIOD);
    assert bus_s(0)  = bus_e(1) report "S(0) does not match E(1)";
    assert bus_s(1) /= bus_e(1) report "S(1) is active";
    assert bus_w(0) /= bus_e(1) report "E(0) is active";
    assert bus_w(1) /= bus_e(1) report "E(1) is active";
    assert bus_n(0) /= bus_e(1) report "N(0) is active";
    assert bus_n(1) /= bus_e(1) report "N(1) is active";
    bus_e(1) <= '1';
    wait for (CLK_PERIOD);
    assert bus_s(0)  = bus_e(1) report "S(0) does not match E(1)";
    assert bus_s(1) /= bus_e(1) report "S(1) is active";
    assert bus_w(0) /= bus_e(1) report "E(0) is active";
    assert bus_w(1) /= bus_e(1) report "E(1) is active";
    assert bus_n(0) /= bus_e(1) report "N(0) is active";
    assert bus_n(1) /= bus_e(1) report "N(1) is active";
    x_6   <= '0';
    sw_24 <= '0';
    sw_31 <= '0';
    bus_e <= (others => 'Z');
    bus_s <= (others => 'Z');

    report "EAST(1) to SOUTH(1)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    x_7   <= '1';
    sw_25 <= '1';
    sw_31 <= '1';
    wait for (CLK_PERIOD);
    bus_e(1) <= '0';
    wait for (CLK_PERIOD);
    assert bus_s(1)  = bus_e(1) report "S(1) does not match E(1)";
    assert bus_s(0) /= bus_e(1) report "S(0) is active";
    assert bus_w(0) /= bus_e(1) report "E(0) is active";
    assert bus_w(1) /= bus_e(1) report "E(1) is active";
    assert bus_n(0) /= bus_e(1) report "N(0) is active";
    assert bus_n(1) /= bus_e(1) report "N(1) is active";
    bus_e(1) <= '1';
    wait for (CLK_PERIOD);
    assert bus_s(1)  = bus_e(1) report "S(1) does not match E(1)";
    assert bus_s(0) /= bus_e(1) report "S(0) is active";
    assert bus_w(0) /= bus_e(1) report "E(0) is active";
    assert bus_w(1) /= bus_e(1) report "E(1) is active";
    assert bus_n(0) /= bus_e(1) report "N(0) is active";
    assert bus_n(1) /= bus_e(1) report "N(1) is active";
    x_7   <= '0';
    sw_25 <= '0';
    sw_31 <= '0';
    bus_e <= (others => 'Z');
    bus_s <= (others => 'Z');

    report "EAST(1) to WEST(1)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    sw_29 <= '1';
    sw_31 <= '1';
    wait for (CLK_PERIOD);
    bus_e(1) <= '0';
    wait for (CLK_PERIOD);
    assert bus_e(1)  = bus_e(1) report "W(1) does not match E(1)";
    assert bus_e(0) /= bus_e(1) report "W(0) is active";
    assert bus_s(0) /= bus_e(1) report "S(0) is active";
    assert bus_s(1) /= bus_e(1) report "S(1) is active";
    assert bus_n(0) /= bus_e(1) report "N(0) is active";
    assert bus_n(1) /= bus_e(1) report "N(1) is active";
    bus_e(1) <= '1';
    wait for (CLK_PERIOD);
    assert bus_e(1)  = bus_e(1) report "W(1) does not match E(1)";
    assert bus_e(0) /= bus_e(1) report "W(0) is active";
    assert bus_s(0) /= bus_e(1) report "S(0) is active";
    assert bus_s(1) /= bus_e(1) report "S(1) is active";
    assert bus_n(0) /= bus_e(1) report "N(0) is active";
    assert bus_n(1) /= bus_e(1) report "N(1) is active";
    sw_29 <= '0';
    sw_31 <= '0';
    bus_e <= (others => 'Z');
    bus_w <= (others => 'Z');
    ----------------------------------------------------------------------------
    report "EAST(0) to NORTH(0)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    x_4   <= '1';
    sw_26 <= '1';
    sw_30 <= '1';
    wait for (CLK_PERIOD);
    bus_e(0) <= '0';
    wait for (CLK_PERIOD);
    assert bus_n(0)  = bus_e(0) report "N(0) does not match E(0)";
    assert bus_n(1) /= bus_e(0) report "N(1) is active";
    assert bus_w(0) /= bus_e(0) report "E(0) is active";
    assert bus_w(1) /= bus_e(0) report "E(1) is active";
    assert bus_s(0) /= bus_e(0) report "S(0) is active";
    assert bus_s(1) /= bus_e(0) report "S(1) is active";
    bus_e(0) <= '1';
    wait for (CLK_PERIOD);
    assert bus_n(0)  = bus_e(0) report "N(0) does not match E(0)";
    assert bus_n(1) /= bus_e(0) report "N(1) is active";
    assert bus_w(0) /= bus_e(0) report "E(0) is active";
    assert bus_w(1) /= bus_e(0) report "E(1) is active";
    assert bus_s(0) /= bus_e(0) report "S(0) is active";
    assert bus_s(1) /= bus_e(0) report "S(1) is active";
    x_4   <= '0';
    sw_26 <= '0';
    sw_30 <= '0';
    bus_e <= (others => 'Z');
    bus_n <= (others => 'Z');

    report "EAST(0) to NORTH(1)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    x_5   <= '1';
    sw_27 <= '1';
    sw_30 <= '1';
    wait for (CLK_PERIOD);
    bus_e(0) <= '0';
    wait for (CLK_PERIOD);
    assert bus_n(1)  = bus_e(0) report "N(1) does not match E(0)";
    assert bus_n(0) /= bus_e(0) report "N(0) is active";
    assert bus_w(0) /= bus_e(0) report "E(0) is active";
    assert bus_w(1) /= bus_e(0) report "E(1) is active";
    assert bus_s(0) /= bus_e(0) report "S(0) is active";
    assert bus_s(1) /= bus_e(0) report "S(1) is active";
    bus_e(0) <= '1';
    wait for (CLK_PERIOD);
    assert bus_n(1)  = bus_e(0) report "N(1) does not match E(0)";
    assert bus_n(0) /= bus_e(0) report "N(0) is active";
    assert bus_w(0) /= bus_e(0) report "E(0) is active";
    assert bus_w(1) /= bus_e(0) report "E(1) is active";
    assert bus_s(0) /= bus_e(0) report "S(0) is active";
    assert bus_s(1) /= bus_e(0) report "S(1) is active";
    x_5   <= '0';
    sw_27 <= '0';
    sw_30 <= '0';
    bus_e <= (others => 'Z');
    bus_n <= (others => 'Z');

    report "EAST(0) to SOUTH(0)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    x_4   <= '1';
    sw_24 <= '1';
    sw_30 <= '1';
    wait for (CLK_PERIOD);
    bus_e(0) <= '0';
    wait for (CLK_PERIOD);
    assert bus_s(0)  = bus_e(0) report "S(0) does not match E(0)";
    assert bus_s(1) /= bus_e(0) report "S(1) is active";
    assert bus_w(0) /= bus_e(0) report "E(0) is active";
    assert bus_w(1) /= bus_e(0) report "E(1) is active";
    assert bus_n(0) /= bus_e(0) report "N(0) is active";
    assert bus_n(1) /= bus_e(0) report "N(1) is active";
    bus_e(0) <= '1';
    wait for (CLK_PERIOD);
    assert bus_s(0)  = bus_e(0) report "S(0) does not match E(0)";
    assert bus_s(1) /= bus_e(0) report "S(1) is active";
    assert bus_w(0) /= bus_e(0) report "E(0) is active";
    assert bus_w(1) /= bus_e(0) report "E(1) is active";
    assert bus_n(0) /= bus_e(0) report "N(0) is active";
    assert bus_n(1) /= bus_e(0) report "N(1) is active";
    x_4   <= '0';
    sw_24 <= '0';
    sw_30 <= '0';
    bus_e <= (others => 'Z');
    bus_s <= (others => 'Z');

    report "EAST(0) to SOUTH(1)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    x_5   <= '1';
    sw_25 <= '1';
    sw_30 <= '1';
    wait for (CLK_PERIOD);
    bus_e(0) <= '0';
    wait for (CLK_PERIOD);
    assert bus_s(1)  = bus_e(0) report "S(1) does not match E(0)";
    assert bus_s(0) /= bus_e(0) report "S(0) is active";
    assert bus_w(0) /= bus_e(0) report "E(0) is active";
    assert bus_w(1) /= bus_e(0) report "E(1) is active";
    assert bus_n(0) /= bus_e(0) report "N(0) is active";
    assert bus_n(1) /= bus_e(0) report "N(1) is active";
    bus_e(0) <= '1';
    wait for (CLK_PERIOD);
    assert bus_s(1)  = bus_e(0) report "S(1) does not match E(0)";
    assert bus_s(0) /= bus_e(0) report "S(0) is active";
    assert bus_w(0) /= bus_e(0) report "E(0) is active";
    assert bus_w(1) /= bus_e(0) report "E(1) is active";
    assert bus_n(0) /= bus_e(0) report "N(0) is active";
    assert bus_n(1) /= bus_e(0) report "N(1) is active";
    x_5   <= '0';
    sw_25 <= '0';
    sw_30 <= '0';
    bus_e <= (others => 'Z');
    bus_s <= (others => 'Z');

    report "EAST(0) to WEST(0)" severity note;
    clear <= '1';
    wait for (CLK_PERIOD);
    clear <= '0';
    wait for (CLK_PERIOD);
    sw_28 <= '1';
    sw_30 <= '1';
    wait for (CLK_PERIOD);
    bus_e(0) <= '0';
    wait for (CLK_PERIOD);
    assert bus_w(0)  = bus_e(0) report "W(1) does not match E(0)";
    assert bus_w(1) /= bus_e(0) report "W(0) is active";
    assert bus_s(0) /= bus_e(0) report "S(0) is active";
    assert bus_s(1) /= bus_e(0) report "S(1) is active";
    assert bus_n(0) /= bus_e(0) report "N(0) is active";
    assert bus_n(1) /= bus_e(0) report "N(1) is active";
    bus_e(0) <= '1';
    wait for (CLK_PERIOD);
    assert bus_w(0)  = bus_e(0) report "W(1) does not match E(0)";
    assert bus_w(1) /= bus_e(0) report "W(0) is active";
    assert bus_s(0) /= bus_e(0) report "S(0) is active";
    assert bus_s(1) /= bus_e(0) report "S(1) is active";
    assert bus_n(0) /= bus_e(0) report "N(0) is active";
    assert bus_n(1) /= bus_e(0) report "N(1) is active";
    sw_28 <= '0';
    sw_30 <= '0';
    bus_e <= (others => 'Z');
    bus_w <= (others => 'Z');
    ----------------------------------------------------------------------------

    wait;
  end process;

  sw_inst : xpoint_double_thru
    port map (
      d_n  => bus_n,
      d_s  => bus_s,
      d_e  => bus_e,
      d_w  => bus_w,
      x_ne => x_6,
      x_nw => x_7,
      x_se => x_4,
      x_sw => x_5,
      en_n => en_n,
      en_s => en_s,
      en_e => en_e,
      en_w => en_w
    );

end bh;
