----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-09-06
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

entity connection_box_horizontal is
  port(
    -- configuration
    sclk  : in  std_logic;
    mosi  : in  std_logic;
    latch : in  std_logic;
    miso  : out std_logic;
    clr_n : in  std_logic;
    -- bus interfaces
    bus_north  : out   std_logic_vector(3 downto 0);
    bus_south  : out   std_logic_vector(3 downto 0);
    bus_east   : inout std_logic_vector(5 downto 0);
    bus_west   : inout std_logic_vector(5 downto 0);
    cout_s     : out   std_logic;
    cout_n     : out   std_logic;
    cin        : in    std_logic;
    ce         : out   std_logic;
    preselect  : out   std_logic_vector(3 downto 0)
  );
end entity;

architecture arch of connection_box_horizontal is

  -- digital bidirectional bus switch
  component cbox is
    port(
      a  : inout std_logic;
      b  : inout std_logic;
      c  : in    std_logic;
      en : in    std_logic
    );
  end component;

  -- 8:1 multiplexer
  component mux_74xx151 is
    port(
      s    : in  std_logic_vector(2 downto 0);
      e_n  : in  std_logic;
      i    : in  std_logic_vector(7 downto 0);
      y    : out std_logic
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

  signal sel_0 : std_logic_vector(2 downto 0) := (others => '0');
  signal sel_1 : std_logic_vector(2 downto 0) := (others => '0');
  signal sel_2 : std_logic_vector(2 downto 0) := (others => '0');
  signal sel_3 : std_logic_vector(2 downto 0) := (others => '0');
  signal xpoint_cin : std_logic;
  signal xpoint_ce  : std_logic;
  signal xpoint_cout_n : std_logic;
  signal xpoint_cout_s : std_logic;

  signal bus_vect : std_logic_vector(7 downto 0); -- signal selection input for 8:1 MUX
  signal bus_prio : std_logic_vector(1 downto 0);

  signal config_ser_data : std_logic;

begin

  config_inst_0 : sr_74xx595
    port map (
      rclk     => latch, 
      srclk    => sclk, 
      srclkr_n => clr_n, 
      oe_n     => '0', 
      ser      => mosi, 
      qa       => sel_0(0),
      qb       => sel_0(1),
      qc       => sel_0(2),
      qd       => xpoint_cin,
      qe       => sel_1(0),
      qf       => sel_1(1),
      qg       => sel_1(2),
      qh       => xpoint_cout_n,
      qh_s     => config_ser_data
    );

  config_inst_1 : sr_74xx595
    port map (
      rclk     => latch, 
      srclk    => sclk, 
      srclkr_n => clr_n, 
      oe_n     => '0', 
      ser      => config_ser_data, 
      qa       => sel_2(0),
      qb       => sel_2(1),
      qc       => sel_2(2),
      qd       => xpoint_cout_s,
      qe       => sel_3(0),
      qf       => sel_3(1),
      qg       => sel_3(2),
      qh       => xpoint_ce,
      qh_s     => miso
    );

  xpoint_cin_inst : cbox 
    port map (
      a  => bus_east(4),
      b  => bus_west(4),
      c  => cin,
      en => xpoint_cin
    );

  ce <= bus_east(5) when xpoint_ce = '1' else 'Z';

  bus_prio(0) <= '1' when bus_east(4) = '1' else
                 '0' when bus_east(4) = '0' else
                 '1' when bus_west(4) = '1' else
                 '0' when bus_west(4) = '0' else 'Z';

  bus_prio(1) <= '1' when bus_east(5) = '1' else
                 '0' when bus_east(5) = '0' else
                 '1' when bus_west(5) = '1' else
                 '0' when bus_west(5) = '0' else 'Z';

  cout_n <= bus_prio(0) when xpoint_cout_n = '1' else 'Z';
  cout_s <= bus_prio(1) when xpoint_cout_s = '1' else 'Z';

  bus_vect(7) <= '0' when bus_east(0) = '0' else 
                 '1' when bus_east(0) = '1' else
                 '0' when bus_west(0) = '0' else 
                 '1' when bus_west(0) = '1' else 'Z';
  bus_vect(6) <= '0' when bus_east(1) = '0' else 
                 '1' when bus_east(1) = '1' else
                 '0' when bus_west(1) = '0' else 
                 '1' when bus_west(1) = '1' else 'Z';
  bus_vect(5) <= '0' when bus_east(2) = '0' else 
                 '1' when bus_east(2) = '1' else
                 '0' when bus_west(2) = '0' else 
                 '1' when bus_west(2) = '1' else 'Z';
  bus_vect(4) <= '0' when bus_east(3) = '0' else 
                 '1' when bus_east(3) = '1' else
                 '0' when bus_west(3) = '0' else 
                 '1' when bus_west(3) = '1' else 'Z';
  
  bus_vect(0) <= '0';
  bus_vect(1) <= '1';
  bus_vect(2) <= bus_prio(1);
  bus_vect(3) <= bus_prio(0);

  bus_north(0) <= bus_vect(7);
  bus_north(1) <= bus_vect(6);
  bus_north(2) <= bus_vect(5);
  bus_north(3) <= bus_vect(4);
  
  bus_south(0) <= bus_vect(7);
  bus_south(1) <= bus_vect(6);
  bus_south(2) <= bus_vect(5);
  bus_south(3) <= bus_vect(4);

  bus_east(0) <= '0' when bus_west(0) = '0' else 
                 '1' when bus_west(0) = '1' else 'Z';
  bus_east(1) <= '0' when bus_west(1) = '0' else 
                 '1' when bus_west(1) = '1' else 'Z';
  bus_east(2) <= '0' when bus_west(2) = '0' else 
                 '1' when bus_west(2) = '1' else 'Z';
  bus_east(3) <= '0' when bus_west(3) = '0' else 
                 '1' when bus_west(3) = '1' else 'Z';

  bus_west(0) <= '0' when bus_east(0) = '0' else 
                 '1' when bus_east(0) = '1' else 'Z';
  bus_west(1) <= '0' when bus_east(1) = '0' else 
                 '1' when bus_east(1) = '1' else 'Z';
  bus_west(2) <= '0' when bus_east(2) = '0' else 
                 '1' when bus_east(2) = '1' else 'Z';
  bus_west(3) <= '0' when bus_east(3) = '0' else 
                 '1' when bus_east(3) = '1' else 'Z';

  preselect_0_inst : mux_74xx151
    port map (
      s   => sel_0,
      e_n => '0',
      i   => bus_vect,
      y   => preselect(0)
    );
  preselect_1_inst : mux_74xx151
    port map (
      s   => sel_1,
      e_n => '0',
      i   => bus_vect,
      y   => preselect(1)
    );
  preselect_2_inst : mux_74xx151
    port map (
      s   => sel_2,
      e_n => '0',
      i   => bus_vect,
      y   => preselect(2)
    );
  preselect_3_inst : mux_74xx151
    port map (
      s   => sel_3,
      e_n => '0',
      i   => bus_vect,
      y   => preselect(3)
    );
  
end architecture;
