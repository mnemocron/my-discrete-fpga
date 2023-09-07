----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-09-07
-- Design Name:    tb_xpoint_thru
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

entity tb_xpoint_thru is

end tb_xpoint_thru;

architecture bh of tb_xpoint_thru is

  component xpoint_thru is
    port(
      d_n  : inout std_logic;
      d_s  : inout std_logic;
      d_e  : inout std_logic;
      d_w  : inout std_logic;
      en_x : in    std_logic;
      en_n : in    std_logic;
      en_s : in    std_logic;
      en_e : in    std_logic;
      en_w : in    std_logic
    );
  end component;

  constant CLK_PERIOD: TIME := 10 ns;

  signal clk        : std_logic;
  signal rst_n      : std_logic;

  signal sn,ss,se,sw : std_logic;
  signal en_n,en_s,en_e,en_w : std_logic;
  signal xp : std_logic;

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
    xp   <= '0';
    en_n <= '0';
    en_s <= '0';
    en_e <= '0';
    en_w <= '0';
    sn  <= 'Z';
    ss  <= 'Z';
    se  <= 'Z';
    sw  <= 'Z';
    wait for (CLK_PERIOD);
    sn <= '1';
    en_n <= '1';
    wait for (CLK_PERIOD);
    assert ss /= '1' report "south is active!";
    assert se /= '1' report "east is active!";
    assert sw /= '1' report "west is active!";
    en_s <= '1';
    wait for (CLK_PERIOD);
    assert ss = sn report "south does not match north!";
    en_e <= '1';
    wait for (CLK_PERIOD);
    assert se /= '1' report "east is active!";
    en_w <= '1';
    wait for (CLK_PERIOD);
    assert sw /= '1' report "west is active!";
    xp <= '1';
    wait for (CLK_PERIOD);
    assert se = sn report "east does not match north!";
    assert sw = sn report "west does not match north!";
    xp <= '0';
    sn <= '0';

    wait for (CLK_PERIOD);
    assert se /= sn report "east is active!";
    assert sw /= sn report "west is active!";

    -- SOUTH to WEST
    report "SOUTH to WEST" severity note;
    en_n <= '0';
    en_s <= '0';
    en_e <= '0';
    en_w <= '0';
    sn  <= 'Z';
    ss  <= 'Z';
    se  <= 'Z';
    sw  <= 'Z';
    wait for (CLK_PERIOD);
    xp <= '1';
    wait for (CLK_PERIOD);
    en_w <= '1';
    en_s <= '1';
    wait for (CLK_PERIOD);
    ss <= '1';
    wait for (CLK_PERIOD);
    assert sw = ss report "west does not match south!";
    assert se /= ss report "east is active!";
    assert sn /= ss report "north is active!";
    ss <= '0';
    wait for (CLK_PERIOD);
    assert sw = ss report "west does not match south!";
    assert se /= ss report "east is active!";
    assert sn /= ss report "north is active!";

    -- SOUTH to EAST
    report "SOUTH to EAST" severity note;
    en_n <= '0';
    en_s <= '0';
    en_e <= '0';
    en_w <= '0';
    sn  <= 'Z';
    ss  <= 'Z';
    se  <= 'Z';
    sw  <= 'Z';
    wait for (CLK_PERIOD);
    xp <= '1';
    wait for (CLK_PERIOD);
    en_e <= '1';
    en_s <= '1';
    wait for (CLK_PERIOD);
    ss <= '1';
    wait for (CLK_PERIOD);
    assert se = ss report "east does not match south!";
    assert sw /= ss report "west is active!";
    assert sn /= ss report "north is active!";
    ss <= '0';
    wait for (CLK_PERIOD);
    assert se = ss report "east does not match south!";
    assert sw /= ss report "west is active!";
    assert sn /= ss report "north is active!";

    -- SOUTH to NORTH
    report "SOUTH to NORTH" severity note;
    en_n <= '0';
    en_s <= '0';
    en_e <= '0';
    en_w <= '0';
    sn  <= 'Z';
    ss  <= 'Z';
    se  <= 'Z';
    sw  <= 'Z';
    wait for (CLK_PERIOD);
    xp <= '1';
    wait for (CLK_PERIOD);
    en_n <= '1';
    en_s <= '1';
    wait for (CLK_PERIOD);
    ss <= '1';
    wait for (CLK_PERIOD);
    assert sn = ss report "north does not match south!";
    assert sw /= ss report "west is active!";
    assert se /= ss report "east is active!";
    ss <= '0';
    wait for (CLK_PERIOD);
    assert sn = ss report "north does not match south!";
    assert sw /= ss report "west is active!";
    assert se /= ss report "east is active!";

    -- EAST to NORTH
    report "EAST to NORTH" severity note;
    en_n <= '0';
    en_s <= '0';
    en_e <= '0';
    en_w <= '0';
    sn  <= 'Z';
    ss  <= 'Z';
    se  <= 'Z';
    sw  <= 'Z';
    wait for (CLK_PERIOD);
    xp <= '1';
    wait for (CLK_PERIOD);
    en_n <= '1';
    en_e <= '1';
    wait for (CLK_PERIOD);
    se <= '1';
    wait for (CLK_PERIOD);
    assert sn = se report "north does not match east!";
    assert sw /= se report "west is active!";
    assert ss /= se report "south is active!";
    se <= '0';
    wait for (CLK_PERIOD);
    assert sn = se report "north does not match east!";
    assert sw /= se report "west is active!";
    assert ss /= se report "south is active!";

    -- EAST to SOUTH
    report "EAST to SOUTH" severity note;
    en_n <= '0';
    en_s <= '0';
    en_e <= '0';
    en_w <= '0';
    sn  <= 'Z';
    ss  <= 'Z';
    se  <= 'Z';
    sw  <= 'Z';
    wait for (CLK_PERIOD);
    xp <= '1';
    wait for (CLK_PERIOD);
    en_s <= '1';
    en_e <= '1';
    wait for (CLK_PERIOD);
    se <= '1';
    wait for (CLK_PERIOD);
    assert ss = se report "south does not match east!";
    assert sw /= se report "west is active!";
    assert sn /= se report "north is active!";
    se <= '0';
    wait for (CLK_PERIOD);
    assert ss = se report "south does not match east!";
    assert sw /= se report "west is active!";
    assert sn /= se report "north is active!";

    -- EAST to WEST
    report "EAST to WEST" severity note;
    en_n <= '0';
    en_s <= '0';
    en_e <= '0';
    en_w <= '0';
    sn  <= 'Z';
    ss  <= 'Z';
    se  <= 'Z';
    sw  <= 'Z';
    wait for (CLK_PERIOD);
    xp <= '1';
    wait for (CLK_PERIOD);
    en_w <= '1';
    en_e <= '1';
    wait for (CLK_PERIOD);
    se <= '1';
    wait for (CLK_PERIOD);
    assert sw = se report "west does not match east!";
    assert ss /= se report "south is active!";
    assert sn /= se report "north is active!";
    se <= '0';
    wait for (CLK_PERIOD);
    assert sw = se report "west does not match east!";
    assert ss /= se report "south is active!";
    assert sn /= se report "north is active!";

    -- NORTH to WEST
    report "NORTH to WEST" severity note;
    en_n <= '0';
    en_s <= '0';
    en_e <= '0';
    en_w <= '0';
    sn  <= 'Z';
    ss  <= 'Z';
    se  <= 'Z';
    sw  <= 'Z';
    wait for (CLK_PERIOD);
    xp <= '1';
    wait for (CLK_PERIOD);
    en_w <= '1';
    en_n <= '1';
    wait for (CLK_PERIOD);
    sn <= '1';
    wait for (CLK_PERIOD);
    assert sw = sn report "west does not match north!";
    assert ss /= sn report "south is active!";
    assert se /= sn report "east is active!";
    sn <= '0';
    wait for (CLK_PERIOD);
    assert sw = sn report "west does not match north!";
    assert ss /= sn report "south is active!";
    assert se /= sn report "east is active!";

    -- NORTH to SOUTH
    report "NORTH to SOUTH" severity note;
    en_n <= '0';
    en_s <= '0';
    en_e <= '0';
    en_w <= '0';
    sn  <= 'Z';
    ss  <= 'Z';
    se  <= 'Z';
    sw  <= 'Z';
    wait for (CLK_PERIOD);
    xp <= '1';
    wait for (CLK_PERIOD);
    en_s <= '1';
    en_n <= '1';
    wait for (CLK_PERIOD);
    sn <= '1';
    wait for (CLK_PERIOD);
    assert ss = sn report "south does not match north!";
    assert sw /= sn report "west is active!";
    assert se /= sn report "east is active!";
    sn <= '0';
    wait for (CLK_PERIOD);
    assert ss = sn report "south does not match north!";
    assert sw /= sn report "west is active!";
    assert se /= sn report "east is active!";

    -- NORTH to EAST
    report "NORTH to EAST" severity note;
    en_n <= '0';
    en_s <= '0';
    en_e <= '0';
    en_w <= '0';
    sn  <= 'Z';
    ss  <= 'Z';
    se  <= 'Z';
    sw  <= 'Z';
    wait for (CLK_PERIOD);
    xp <= '1';
    wait for (CLK_PERIOD);
    en_e <= '1';
    en_n <= '1';
    wait for (CLK_PERIOD);
    sn <= '1';
    wait for (CLK_PERIOD);
    assert se = sn report "east does not match north!";
    assert sw /= sn report "west is active!";
    assert ss /= sn report "south is active!";
    sn <= '0';
    wait for (CLK_PERIOD);
    assert se = sn report "east does not match north!";
    assert sw /= sn report "west is active!";
    assert ss /= sn report "south is active!";

    -- WEST to EAST
    report "WEST to EAST" severity note;
    en_n <= '0';
    en_s <= '0';
    en_e <= '0';
    en_w <= '0';
    sn  <= 'Z';
    ss  <= 'Z';
    se  <= 'Z';
    sw  <= 'Z';
    wait for (CLK_PERIOD);
    xp <= '1';
    wait for (CLK_PERIOD);
    en_e <= '1';
    en_w <= '1';
    wait for (CLK_PERIOD);
    sw <= '1';
    wait for (CLK_PERIOD);
    assert se = sw report "east does not match west!";
    assert sn /= sw report "north is active!";
    assert ss /= sw report "south is active!";
    sw <= '0';
    wait for (CLK_PERIOD);
    assert se = sw report "east does not match west!";
    assert sn /= sw report "north is active!";
    assert ss /= sw report "south is active!";

    -- WEST to NORTH
    report "WEST to NORTH" severity note;
    en_n <= '0';
    en_s <= '0';
    en_e <= '0';
    en_w <= '0';
    sn  <= 'Z';
    ss  <= 'Z';
    se  <= 'Z';
    sw  <= 'Z';
    wait for (CLK_PERIOD);
    xp <= '1';
    wait for (CLK_PERIOD);
    en_n <= '1';
    en_w <= '1';
    wait for (CLK_PERIOD);
    sw <= '1';
    wait for (CLK_PERIOD);
    assert sn = sw report "north does not match west!";
    assert se /= sw report "east is active!";
    assert ss /= sw report "south is active!";
    sw <= '0';
    wait for (CLK_PERIOD);
    assert sn = sw report "north does not match west!";
    assert se /= sw report "east is active!";
    assert ss /= sw report "south is active!";

    -- WEST to SOUTH
    report "WEST to SOUTH" severity note;
    en_n <= '0';
    en_s <= '0';
    en_e <= '0';
    en_w <= '0';
    sn  <= 'Z';
    ss  <= 'Z';
    se  <= 'Z';
    sw  <= 'Z';
    wait for (CLK_PERIOD);
    xp <= '1';
    wait for (CLK_PERIOD);
    en_s <= '1';
    en_w <= '1';
    wait for (CLK_PERIOD);
    sw <= '1';
    wait for (CLK_PERIOD);
    assert ss = sw report "south does not match west!";
    assert se /= sw report "east is active!";
    assert sn /= sw report "north is active!";
    sw <= '0';
    wait for (CLK_PERIOD);
    assert ss = sw report "south does not match west!";
    assert se /= sw report "east is active!";
    assert sn /= sw report "north is active!";




    -- set one direction but en not active


    wait;
  end process;

  sw_inst : xpoint_thru
    port map (
      d_n  => sn,
      d_s  => ss,
      d_e  => se,
      d_w  => sw,
      en_x => xp,
      en_n => en_n,
      en_s => en_s,
      en_e => en_e,
      en_w => en_w
    );

end bh;
