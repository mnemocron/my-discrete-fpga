----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-09-17
-- Design Name:    tb_fpga_arch_tile
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
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_fpga_arch_tile is

end tb_fpga_arch_tile;

architecture bh of tb_fpga_arch_tile is

  component fpga_arch_tile is
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
      net_bus_east   : inout std_logic_vector(5 downto 0);
      net_prio_north : inout std_logic_vector(1 downto 0);
      net_prio_south : inout std_logic_vector(1 downto 0);
      net_prio_west  : inout std_logic_vector(1 downto 0);
      net_prio_east  : inout std_logic_vector(1 downto 0)
    );
  end component;

  constant CLK_PERIOD: TIME := 5 ns;
  constant SPI_CLK_PERIOD: TIME := 1 ns;

  signal clk        : std_logic;
  signal clk_1      : std_logic;
  signal rst_n      : std_logic;

  -- bitstream configuration SPI interface
  signal sclk       : std_logic;
  signal miso       : std_logic;
  signal mosi       : std_logic;
  signal latch      : std_logic;
  signal cfg_clr_n  : std_logic;

  -- slice interface
  signal cin          : std_logic;
  signal cout         : std_logic;

  signal clb_west  : std_logic_vector(3 downto 0) := (others => 'Z');
  signal clb_east  : std_logic_vector(3 downto 0) := (others => 'Z');
  signal clb_north : std_logic_vector(3 downto 0) := (others => 'Z');
  signal clb_south : std_logic_vector(3 downto 0) := (others => 'Z');

  signal bus_west  : std_logic_vector(5 downto 0) := (others => 'Z');
  signal bus_east  : std_logic_vector(5 downto 0) := (others => 'Z');
  signal bus_north : std_logic_vector(5 downto 0) := (others => 'Z');
  signal bus_south : std_logic_vector(5 downto 0) := (others => 'Z');

  signal prio_west  : std_logic_vector(1 downto 0) := (others => 'Z');
  signal prio_east  : std_logic_vector(1 downto 0) := (others => 'Z');
  signal prio_north : std_logic_vector(1 downto 0) := (others => 'Z');
  signal prio_south : std_logic_vector(1 downto 0) := (others => 'Z');

  -- housekeeping
  signal clk_count  : std_logic_vector(31 downto 0) := (others => '0');
  signal bitstream_done : std_logic := '0';
  signal test_done : std_logic := '0';
begin

  -- generate clk signal
  p_clk_gen : process
  begin
   clk <= '1';
   wait for (CLK_PERIOD / 2);
   clk <= '0';
   wait for (CLK_PERIOD / 2);
   if rst_n = '1' then
     clk_count <= std_logic_vector(unsigned(clk_count) + 1);
    end if;
  end process;

  -- generate clk signal
  p_clk_gen_1 : process
  begin
   clk_1 <= '1';
   wait for (CLK_PERIOD / 3);
   clk_1 <= '0';
   wait for (CLK_PERIOD / 3);
  end process;


  proc_bitstream_programming : process
    file bitstream_file : text open read_mode is "bitstream.txt";
    variable text_line : line;
    variable ok : boolean;
    variable conf_byte : std_logic_vector(7 downto 0);
  begin
    sclk <= '0';
    mosi <= 'Z';
    latch <= '0';
    cfg_clr_n <= '0';
    wait for 5 ns;
    cfg_clr_n <= '1';
    wait for 5 ns;
    latch <= '1';
    wait for 5 ns;
    latch <= '0';
    wait for 5 ns;

    while not endfile(bitstream_file) loop  
      readline(bitstream_file, text_line);
      -- skip empty and comment lines
      if text_line.all'length = 0 or text_line.all(1) = '#' then
        next;
      end if;
      read(text_line, conf_byte, ok);
      assert ok
        report "Read 'conf_byte' failed for line: " & text_line.all
        severity failure;

      l_send_byte : for k in conf_byte'length-1 downto 0 loop
        mosi <= conf_byte(k);
        wait for (SPI_CLK_PERIOD / 2);
        sclk <= '1';
        wait for (SPI_CLK_PERIOD / 2);
        sclk <= '0';
      end loop l_send_byte;
    end loop;

    wait for 5 ns;
    latch <= '1';
    wait for 5 ns;
    latch <= '0';
    wait for 5 ns;
    bitstream_done <= '1';

    wait until test_done = '1';

    wait;
    -- finish;
  end process;

  -- generate initial reset
  p_reset_gen : process
  begin 
    rst_n <= '0';
    wait until rising_edge(bitstream_done);
    wait for (CLK_PERIOD / 4);
    wait until rising_edge(clk);
    rst_n <= '1';
    wait;
  end process;


  p_test : process(clk)
  begin

    if unsigned(clk_count) = 2 then
    
    end if;

  end process;

  bcinst : fpga_arch_tile 
    port map (
      sclk       => sclk,
      mosi       => mosi,
      latch      => latch,
      miso       => miso,
      clr_n      => cfg_clr_n,

      i_clk_0    => clk,
      i_clk_1    => clk_1,
      fpga_arstn => rst_n,

      clb_north      => clb_north,
      clb_south      => clb_south,
      clb_west       => clb_west,
      clb_east       => clb_east,

      cout_north     => cout,
      cin_south      => cin,

      net_bus_north  => bus_north,
      net_bus_south  => bus_south,
      net_bus_west   => bus_west,
      net_bus_east   => bus_east,

      net_prio_north => prio_north,
      net_prio_south => prio_south,
      net_prio_west  => prio_west,
      net_prio_east  => prio_east
    );
  

end bh;
