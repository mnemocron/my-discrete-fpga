----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-09-09
-- Design Name:    tb_sw_box
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

entity tb_sw_box is

end tb_sw_box;

architecture bh of tb_sw_box is

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

  component bus_io_dummy is
    port(
      bus_a  : inout std_logic_vector(5 downto 0);
      bus_b  : inout std_logic_vector(5 downto 0)
    );
  end component;

  constant CLK_PERIOD: TIME := 5 ns;
  constant SPI_CLK_PERIOD: TIME := 1 ns;

  signal clk        : std_logic;
  signal rst_n      : std_logic;

  -- bitstream configuration SPI interface
  signal sclk       : std_logic;
  signal miso       : std_logic;
  signal mosi       : std_logic;
  signal latch      : std_logic;
  signal cfg_clr_n  : std_logic;

  signal cb_bus_west  : std_logic_vector(5 downto 0);
  signal cb_bus_east  : std_logic_vector(5 downto 0);
  signal cb_bus_north : std_logic_vector(5 downto 0);
  signal cb_bus_south : std_logic_vector(5 downto 0);
  signal cb_prio_north : std_logic_vector(1 downto 0);
  signal cb_prio_south : std_logic_vector(1 downto 0);
  signal cb_prio_west : std_logic_vector(1 downto 0);
  signal cb_prio_east : std_logic_vector(1 downto 0);

  signal cb_bus_west_copy  : std_logic_vector(5 downto 0);
  signal cb_bus_east_copy  : std_logic_vector(5 downto 0);
  signal cb_bus_north_copy : std_logic_vector(5 downto 0);
  signal cb_bus_south_copy : std_logic_vector(5 downto 0);
  signal cb_prio_north_copy : std_logic_vector(1 downto 0);
  signal cb_prio_south_copy : std_logic_vector(1 downto 0);
  signal cb_prio_west_copy : std_logic_vector(1 downto 0);
  signal cb_prio_east_copy : std_logic_vector(1 downto 0);

  signal cb_bus_west_buf  : std_logic_vector(5 downto 0);
  signal cb_bus_east_buf  : std_logic_vector(5 downto 0);
  signal cb_bus_north_buf : std_logic_vector(5 downto 0);
  signal cb_bus_south_buf : std_logic_vector(5 downto 0);
  signal cb_prio_north_buf : std_logic_vector(1 downto 0);
  signal cb_prio_south_buf : std_logic_vector(1 downto 0);
  signal cb_prio_west_buf : std_logic_vector(1 downto 0);
  signal cb_prio_east_buf : std_logic_vector(1 downto 0);

  signal pri_n0 : std_logic;
  signal pri_n1 : std_logic;
  signal pri_s0 : std_logic;
  signal pri_s1 : std_logic;
  signal pri_e0 : std_logic;
  signal pri_e1 : std_logic;
  signal pri_w0 : std_logic;
  signal pri_w1 : std_logic;

  signal cbn_0 : std_logic;
  signal cbn_1 : std_logic;
  signal cbn_2 : std_logic;
  signal cbn_3 : std_logic;

  signal cbs_0 : std_logic;
  signal cbs_1 : std_logic;
  signal cbs_2 : std_logic;
  signal cbs_3 : std_logic;

  signal cbe_0 : std_logic;
  signal cbe_1 : std_logic;
  signal cbe_2 : std_logic;
  signal cbe_3 : std_logic;

  signal cbw_0 : std_logic;
  signal cbw_1 : std_logic;
  signal cbw_2 : std_logic;
  signal cbw_3 : std_logic;

  signal exp_cbn_0 : std_logic;
  signal exp_cbn_1 : std_logic;
  signal exp_cbn_2 : std_logic;
  signal exp_cbn_3 : std_logic;

  signal exp_cbs_0 : std_logic;
  signal exp_cbs_1 : std_logic;
  signal exp_cbs_2 : std_logic;
  signal exp_cbs_3 : std_logic;

  signal exp_cbe_0 : std_logic;
  signal exp_cbe_1 : std_logic;
  signal exp_cbe_2 : std_logic;
  signal exp_cbe_3 : std_logic;

  signal exp_cbw_0 : std_logic;
  signal exp_cbw_1 : std_logic;
  signal exp_cbw_2 : std_logic;
  signal exp_cbw_3 : std_logic;

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

  pri_w0 <= cb_prio_west(0);
  pri_w1 <= cb_prio_west(1);
  pri_e0 <= cb_prio_east(0);
  pri_e1 <= cb_prio_east(1);

  pri_n0 <= cb_prio_north(0);
  pri_n1 <= cb_prio_north(1);
  pri_s0 <= cb_prio_south(0);
  pri_s1 <= cb_prio_south(1);

  cbn_0 <= cb_bus_north(0);
  cbn_1 <= cb_bus_north(1);
  cbn_2 <= cb_bus_north(2);
  cbn_3 <= cb_bus_north(3);

  cbs_0 <= cb_bus_south(0);
  cbs_1 <= cb_bus_south(1);
  cbs_2 <= cb_bus_south(2);
  cbs_3 <= cb_bus_south(3);

  cbe_0 <= cb_bus_east(0);
  cbe_1 <= cb_bus_east(1);
  cbe_2 <= cb_bus_east(2);
  cbe_3 <= cb_bus_east(3);

  cbw_0 <= cb_bus_west(0);
  cbw_1 <= cb_bus_west(1);
  cbw_2 <= cb_bus_west(2);
  cbw_3 <= cb_bus_west(3);

  exp_cbn_0 <= cb_bus_north_buf(0);
  exp_cbn_1 <= cb_bus_north_buf(1);
  exp_cbn_2 <= cb_bus_north_buf(2);
  exp_cbn_3 <= cb_bus_north_buf(3);

  exp_cbs_0 <= cb_bus_south_buf(0);
  exp_cbs_1 <= cb_bus_south_buf(1);
  exp_cbs_2 <= cb_bus_south_buf(2);
  exp_cbs_3 <= cb_bus_south_buf(3);

  exp_cbe_0 <= cb_bus_east_buf(0);
  exp_cbe_1 <= cb_bus_east_buf(1);
  exp_cbe_2 <= cb_bus_east_buf(2);
  exp_cbe_3 <= cb_bus_east_buf(3);

  exp_cbw_0 <= cb_bus_west_buf(0);
  exp_cbw_1 <= cb_bus_west_buf(1);
  exp_cbw_2 <= cb_bus_west_buf(2);
  exp_cbw_3 <= cb_bus_west_buf(3);

  cb_bus_south <= clk_count(5 downto 0);
  cb_prio_north <= clk_count(2 downto 1);

  cb_bus_south_copy <= clk_count(5 downto 0);
  cb_prio_north_copy <= clk_count(2 downto 1);

  p_test : process(clk)
  begin

    if unsigned(clk_count) = 2 then
    
    end if;

  end process;

  bcinst : sw_box 
    port map (
      sclk       => sclk,
      mosi       => mosi,
      latch      => latch,
      miso       => miso,
      clr_n      => cfg_clr_n,
      bus_north  => cb_bus_north,
      bus_south  => cb_bus_south,
      bus_east   => cb_bus_east,
      bus_west   => cb_bus_west
    );

  con_inst : sw_box 
    port map (
      sclk       => sclk,
      mosi       => mosi,
      latch      => latch,
      miso       => miso,
      clr_n      => cfg_clr_n,
      bus_north  => cb_bus_north_copy,
      bus_south  => open,
      bus_east   => cb_bus_east_copy,
      bus_west   => cb_bus_west_copy
    );

  src_bus_inst : bus_io_dummy
    port map (
      bus_a  => cb_bus_south_copy,
      bus_b  => cb_bus_south_buf
    );

end bh;
