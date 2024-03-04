----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-09-09
-- Design Name:    
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

entity sw_box is
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
    bus_east   : inout std_logic_vector(3 downto 0);
    bus_west   : inout std_logic_vector(3 downto 0);
    prio_north : inout std_logic_vector(1 downto 0);
    prio_south : inout std_logic_vector(1 downto 0);
    prio_east  : inout std_logic_vector(1 downto 0);
    prio_west  : inout std_logic_vector(1 downto 0)
  );
end entity;

architecture arch of sw_box is

  -- digital bidirectional bus switch
  component digital_switch is
    port(
      en : in    std_logic;
      d1 : inout std_logic;
      d2 : inout std_logic
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

--  component xpoint_thru is
--    port(
--      d_n  : inout std_logic;
--      d_s  : inout std_logic;
--      d_e  : inout std_logic;
--      d_w  : inout std_logic;
--      en_x : in    std_logic;
--      en_n : in    std_logic;
--      en_s : in    std_logic;
--      en_e : in    std_logic;
--      en_w : in    std_logic
--    );
--  end component;

  component newsw is
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

  signal bus_vect : std_logic_vector(7 downto 0);
  signal bus_prio : std_logic_vector(1 downto 0);

  signal prio_lane   : std_logic_vector(1 downto 0);
  signal xpoint_0 : std_logic;
  signal xpoint_1 : std_logic;
  signal xpoint_2 : std_logic;
  signal xpoint_3 : std_logic;
  signal xpoint_4 : std_logic;
  signal xpoint_5 : std_logic;
  signal xpoint_6 : std_logic;
  signal xpoint_7 : std_logic;
  signal sw_8, sw_9, sw_10,sw_11 : std_logic;
  signal sw_12,sw_13,sw_14,sw_15 : std_logic;
  signal sw_16,sw_17,sw_18,sw_19 : std_logic;
  signal sw_20,sw_21,sw_22,sw_23 : std_logic;
  signal sw_24,sw_25,sw_26,sw_27 : std_logic;
  signal sw_28,sw_29,sw_30,sw_31 : std_logic;
  signal xpoint_4_5 : std_logic;
  signal xpoint_6_7 : std_logic;
  signal xpoint_5_7 : std_logic;
  signal xpoint_4_6 : std_logic;

  signal conf_ser_data_0 : std_logic;
  signal conf_ser_data_1 : std_logic;
  signal conf_ser_data_2 : std_logic;

begin

  config_inst_0 : sr_74xx595
    port map (
      rclk     => latch, 
      srclk    => sclk, 
      srclkr_n => clr_n, 
      oe_n     => '0', 
      ser      => conf_ser_data_2, 
      qa       => xpoint_0,
      qb       => xpoint_1,
      qc       => xpoint_2,
      qd       => xpoint_3,
      qe       => xpoint_4,
      qf       => xpoint_5,
      qg       => xpoint_6,
      qh       => xpoint_7,
      qh_s     => miso
    );

  config_inst_1 : sr_74xx595
    port map (
      rclk     => latch, 
      srclk    => sclk, 
      srclkr_n => clr_n, 
      oe_n     => '0', 
      ser      => conf_ser_data_1,
      qa       => sw_8,
      qb       => sw_9,
      qc       => sw_10,
      qd       => sw_11,
      qe       => sw_12,
      qf       => sw_13,
      qg       => sw_14,
      qh       => sw_15,
      qh_s     => conf_ser_data_2
    );

  config_inst_2 : sr_74xx595
    port map (
      rclk     => latch, 
      srclk    => sclk, 
      srclkr_n => clr_n, 
      oe_n     => '0', 
      ser      => conf_ser_data_0,
      qa       => sw_16,
      qb       => sw_17,
      qc       => sw_18,
      qd       => sw_19,
      qe       => sw_20,
      qf       => sw_21,
      qg       => sw_22,
      qh       => sw_23,
      qh_s     => conf_ser_data_1
    );

  config_inst_3 : sr_74xx595
    port map (
      rclk     => latch, 
      srclk    => sclk, 
      srclkr_n => clr_n, 
      oe_n     => '0', 
      ser      => mosi,
      qa       => sw_24,
      qb       => sw_25,
      qc       => sw_26,
      qd       => sw_27,
      qe       => sw_28,
      qf       => sw_29,
      qg       => sw_30,
      qh       => sw_31,
      qh_s     => conf_ser_data_0
    );

  xpoint_0_inst : newsw
    port map (
      d_n  => bus_north(0),
      d_s  => bus_south(0),
      d_e  => bus_east(0),
      d_w  => bus_west(0),
      en_x => xpoint_0,
      en_n => sw_12,
      en_s => sw_8,
      en_e => sw_20,
      en_w => sw_16
    );
  xpoint_1_inst : newsw
    port map (
      d_n  => bus_north(1),
      d_s  => bus_south(1),
      d_e  => bus_east(1),
      d_w  => bus_west(1),
      en_x => xpoint_1,
      en_n => sw_13,
      en_s => sw_9,
      en_e => sw_21,
      en_w => sw_17
    );
  xpoint_2_inst : newsw
    port map (
      d_n  => bus_north(2),
      d_s  => bus_south(2),
      d_e  => bus_east(2),
      d_w  => bus_west(2),
      en_x => xpoint_2,
      en_n => sw_14,
      en_s => sw_10,
      en_e => sw_22,
      en_w => sw_18
    );
  xpoint_3_inst : newsw
    port map (
      d_n  => bus_north(3),
      d_s  => bus_south(3),
      d_e  => bus_east(3),
      d_w  => bus_west(3),
      en_x => xpoint_3,
      en_n => sw_15,
      en_s => sw_11,
      en_e => sw_23,
      en_w => sw_19
    );


  xpoint_4_inst : newsw
    port map (
      d_n  => xpoint_4_6,
      d_s  => prio_south(0),
      d_e  => xpoint_4_5,
      d_w  => prio_east(0),
      en_x => xpoint_4,
      en_n => '1',
      en_s => sw_24,
      en_e => sw_30,
      en_w => '1'
    );
  xpoint_5_inst : newsw
    port map (
      d_n  => xpoint_5_7,
      d_s  => prio_south(1),
      d_e  => xpoint_4_5,
      d_w  => prio_west(0),
      en_x => xpoint_5,
      en_n => '1',
      en_s => sw_25,
      en_e => '1',
      en_w => sw_28
    );
  xpoint_6_inst : newsw
    port map (
      d_n  => prio_north(0),
      d_s  => xpoint_4_6,
      d_e  => prio_east(1),
      d_w  => xpoint_6_7,
      en_x => xpoint_6,
      en_n => sw_26,
      en_s => '1',
      en_e => sw_31,
      en_w => '1'
    );
  xpoint_7_inst : newsw
    port map (
      d_n  => prio_north(1),
      d_s  => xpoint_5_7,
      d_e  => xpoint_6_7,
      d_w  => prio_west(1),
      en_x => xpoint_7,
      en_n => sw_27,
      en_s => '1',
      en_e => '1',
      en_w => sw_29
    );
  
end architecture;
