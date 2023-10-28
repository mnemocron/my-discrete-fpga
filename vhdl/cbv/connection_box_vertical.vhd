----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-09-05
-- Design Name:    
-- Module Name:    
-- Project Name:   
-- Target Devices: 
-- Tool Versions:  GHDL 4.0.0-dev
-- Description:    
-- Dependencies:   
-- 
-- Revision:       1.0.0
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity connection_box_vertical is
  port(
    -- configuration
    sclk  : in  std_logic;
    mosi  : in  std_logic;
    latch : in  std_logic;
    miso  : out std_logic;
    clr_n : in  std_logic;
    -- bus interfaces
    bus_north  : inout std_logic_vector(3 downto 0);
    bus_south  : inout std_logic_vector(3 downto 0);
    bus_east   : out   std_logic_vector(3 downto 0);
    bus_west   : in    std_logic_vector(3 downto 0);
    prio_north : inout std_logic_vector(1 downto 0);
    prio_south : inout std_logic_vector(1 downto 0)
  );
end entity;

architecture arch of connection_box_vertical is

  -- digital bidirectional bus switch
  component cbox is
    port(
      a  : inout std_logic;
      b  : inout std_logic;
      c  : in    std_logic;
      en : in    std_logic
    );
  end component;

  -- 8-bit Shift Register
  component sr_74xx595 is
    port(
      rclk     : in  std_logic; -- register latch clock
      srclk    : in  std_logic; -- serial clock
      srclkr_n : in  std_logic; -- register clear
      oe_n     : in  std_logic; 
      ser      : in  std_logic;
      qa       : out std_logic;
      qb       : out std_logic;
      qc       : out std_logic;
      qd       : out std_logic;
      qe       : out std_logic;
      qf       : out std_logic;
      qg       : out std_logic;
      qh       : out std_logic;
      qh_s     : out std_logic
    );
  end component;

  signal xpoint_0_en : std_logic := '0';
  signal xpoint_1_en : std_logic := '0';
  signal xpoint_2_en : std_logic := '0';
  signal xpoint_3_en : std_logic := '0';
  signal xpoint_4_en : std_logic := '0';
  signal xpoint_5_en : std_logic := '0';
  signal xpoint_6_en : std_logic := '0';
  signal xpoint_7_en : std_logic := '0';

begin

  p_assert : process(latch) -- process(xpoint_0_en,xpoint_1_en,xpoint_2_en,xpoint_3_en,xpoint_4_en,xpoint_5_en,xpoint_6_en,xpoint_7_en)
  begin
    if falling_edge(latch) then
      assert (xpoint_4_en and xpoint_6_en) = '0' report "crosspoints (4) and (6) are driving each other!";
      assert (xpoint_5_en and xpoint_7_en) = '0' report "crosspoints (5) and (7) are driving each other!";
    end if;
  end process;

  bus_east <= bus_west; -- pass through

  config_inst : sr_74xx595
    port map (
      rclk     => latch, 
      srclk    => sclk, 
      srclkr_n => clr_n, 
      oe_n     => '0', 
      ser      => mosi, 
      qa       => xpoint_0_en,
      qb       => xpoint_1_en,
      qc       => xpoint_2_en,
      qd       => xpoint_3_en,
      qe       => xpoint_4_en,
      qf       => xpoint_5_en,
      qg       => xpoint_6_en,
      qh       => xpoint_7_en,
      qh_s     => miso
    );

  xpoint_0_inst : cbox 
    port map (
      a  => bus_north(3),
      b  => bus_south(3),
      c  => bus_west(3),
      en => xpoint_0_en
    );
  xpoint_1_inst : cbox 
    port map (
      a  => bus_north(2),
      b  => bus_south(2),
      c  => bus_west(2),
      en => xpoint_1_en
    );
  xpoint_2_inst : cbox 
    port map (
      a  => bus_north(1),
      b  => bus_south(1),
      c  => bus_west(1),
      en => xpoint_2_en
    );
  xpoint_3_inst : cbox 
    port map (
      a  => bus_north(0),
      b  => bus_south(0),
      c  => bus_west(0),
      en => xpoint_3_en
    );
  xpoint_4_inst : cbox 
    port map (
      a  => prio_north(1),
      b  => prio_south(1),
      c  => bus_west(0),
      en => xpoint_4_en
    );
  xpoint_5_inst : cbox 
    port map (
      a  => prio_north(0),
      b  => prio_south(0),
      c  => bus_west(1),
      en => xpoint_5_en
    );
  xpoint_6_inst : cbox 
    port map (
      a  => prio_north(1),
      b  => prio_south(1),
      c  => bus_west(2),
      en => xpoint_6_en
    );
  xpoint_7_inst : cbox 
    port map (
      a  => prio_north(0),
      b  => prio_south(0),
      c  => bus_west(3),
      en => xpoint_7_en
    );

end architecture;
