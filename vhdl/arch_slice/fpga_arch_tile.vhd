----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-09-17
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
--   The tile consists of 4 components
--     Quadrant 1: SW box
--     Quadrant 2: CBh
--     Quadrant 3: CLB
--     Quadrant 4: CBv
--   The bitstream is passed in order of quadrants 1 --> 4
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fpga_arch_tile is
  port(
    -- configuration
    sclk  : in  std_logic;
    mosi  : in  std_logic;
    latch : in  std_logic;
    miso  : out std_logic;
    clr_n : in  std_logic;
    -- clk interface
    i_clk_0    : in  std_logic;
    i_clk_1    : in  std_logic;
    fpga_arstn : in  std_logic; -- active low 74LS175
    -- bus interfaces
    clb_north      : out   std_logic_vector(3 downto 0);
    clb_south      : in    std_logic_vector(3 downto 0);
    clb_west       : in    std_logic_vector(3 downto 0);
    clb_east       : out   std_logic_vector(3 downto 0);
    cout_north     : out   std_logic;
    cin_south      : in    std_logic;
    net_bus_north  : inout std_logic_vector(5 downto 0);
    net_bus_south  : inout std_logic_vector(5 downto 0);
    net_bus_west   : inout std_logic_vector(5 downto 0);
    net_bus_east   : inout std_logic_vector(5 downto 0)
  );
end entity;

architecture arch of fpga_arch_tile is

  component sw_box is
    port(
      -- configuration
      sclk  : in  std_logic;
      mosi  : in  std_logic;
      latch : in  std_logic;
      miso  : out std_logic;
      clr_n : in  std_logic;
      -- bus interfaces
      bus_north  : inout std_logic_vector(5 downto 0);
      bus_south  : inout std_logic_vector(5 downto 0);
      bus_east   : inout std_logic_vector(5 downto 0);
      bus_west   : inout std_logic_vector(5 downto 0)
    );
  end component;

  component connection_box_horizontal is
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
  end component;

  component clb_slice is
    port(
      -- clocking and reset
      clk_0 : in  std_logic;
      clk_1 : in  std_logic;
      rst_n : in  std_logic;
      -- configuration
      sclk  : in  std_logic;
      mosi  : in  std_logic;
      latch : in  std_logic;
      miso  : out std_logic;
      clr_n : in  std_logic;
      ce    : in  std_logic;
      -- LUT outputs
      Qa    : out std_logic;
      Qb    : out std_logic;
      Qc    : out std_logic;
      Qd    : out std_logic;
      -- connection box ports
      cin    : in  std_logic;
      cout   : out std_logic;
      cb_w   : in  std_logic_vector(3 downto 0);
      cb_n   : in  std_logic_vector(3 downto 0);
      cb_s   : in  std_logic_vector(3 downto 0);
      cb_pre : in  std_logic_vector(3 downto 0)
    );
  end component;

  component connection_box_vertical is
    port(
      -- configuration
      sclk  : in  std_logic;
      mosi  : in  std_logic;
      latch : in  std_logic;
      miso  : out std_logic;
      clr_n : in  std_logic;
      -- bus interfaces
      bus_north  : inout std_logic_vector(5 downto 0);
      bus_south  : inout std_logic_vector(5 downto 0);
      bus_east   : out   std_logic_vector(3 downto 0);
      bus_west   : in    std_logic_vector(3 downto 0)
    );
  end component;

  signal s_sclk   : std_logic;
  signal s_latch  : std_logic;
  signal s_clr_n  : std_logic;
  signal areset_n : std_logic := '1';

  signal btstrm_in         : std_logic;
  signal btstrm_swb_to_cbh : std_logic;
  signal btstrm_cbh_to_clb : std_logic;
  signal btstrm_clb_to_cbv : std_logic;
  signal btstrm_out        : std_logic;

  signal clk_0 : std_logic;
  signal clk_1 : std_logic;

  signal s_bus_swb_cbv    : std_logic_vector(5 downto 0);
  signal s_bus_swb_cbh    : std_logic_vector(5 downto 0);
  signal s_cin_cbh_clb    : std_logic;
  signal s_cout_clb_cbh   : std_logic;
  signal s_presel_cbh_clb : std_logic_vector(3 downto 0);
  signal s_bus_cbh_clb    : std_logic_vector(3 downto 0);
  signal s_ce             : std_logic;

  signal lut_q : std_logic_vector(3 downto 0);


begin
  
  s_latch <= latch;
  s_sclk  <= sclk;
  s_clr_n <= clr_n;

  clk_0 <= i_clk_0;
  clk_1 <= i_clk_1;

  btstrm_in <= mosi;

  swb_inst : sw_box 
    port map (
      -- configuration
      sclk  => s_sclk,
      mosi  => btstrm_in,
      latch => s_latch,
      miso  => btstrm_swb_to_cbh,
      clr_n => s_clr_n,
      -- bus interfaces
      bus_north  => net_bus_north,
      bus_south  => s_bus_swb_cbv,
      bus_east   => net_bus_east,
      bus_west   => s_bus_swb_cbh
    );

  cbh_inst : connection_box_horizontal 
    port map (
      -- configuration
      sclk  => s_sclk,
      mosi  => btstrm_swb_to_cbh,
      latch => s_latch,
      miso  => btstrm_cbh_to_clb,
      clr_n => s_clr_n,
      -- bus interfaces
      bus_north  => clb_north,
      bus_south  => s_bus_cbh_clb,
      bus_east   => s_bus_swb_cbh,
      bus_west   => net_bus_west,
      cout_s     => s_cin_cbh_clb,
      cout_n     => cout_north,
      cin        => s_cout_clb_cbh,
      ce         => s_ce,
      preselect  => s_presel_cbh_clb
    );

  clb_inst : clb_slice
    port map (
      -- clocking and reset
      clk_0 => clk_0,
      clk_1 => clk_1,
      rst_n => areset_n,
      -- configuration
      sclk  => s_sclk,
      mosi  => btstrm_cbh_to_clb,
      latch => s_latch,
      miso  => btstrm_clb_to_cbv,
      clr_n => s_clr_n,
      ce    => s_ce,
      -- LUT outputs
      Qa    => lut_q(0),
      Qb    => lut_q(1),
      Qc    => lut_q(2),
      Qd    => lut_q(3),
      -- connection box ports
      cin    => s_cin_cbh_clb,
      cout   => s_cout_clb_cbh,
      cb_w   => clb_west,
      cb_n   => s_bus_cbh_clb,
      cb_s   => clb_south,
      cb_pre => s_presel_cbh_clb
    );

  cbv_inst : connection_box_vertical 
    port map (
      -- configuration
      sclk  => s_sclk,
      mosi  => btstrm_clb_to_cbv,
      latch => s_latch,
      miso  => btstrm_out,
      clr_n => s_clr_n,
      -- bus interfaces
      bus_north  => s_bus_swb_cbv,
      bus_south  => net_bus_south,
      bus_east   => clb_east,
      bus_west   => lut_q
    );


  miso <= btstrm_out;
  
end architecture;
