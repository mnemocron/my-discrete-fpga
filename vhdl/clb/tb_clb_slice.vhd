----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-09-03
-- Design Name:    tb_clb_slice
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

entity tb_clb_slice is

end tb_clb_slice;

architecture bh of tb_clb_slice is

  component clb_slice is
    port(
      -- clocking and reset
      clk_0 : in  std_ulogic;
      clk_1 : in  std_ulogic;
      rst_n : in  std_ulogic;
      -- configuration
      sclk  : in  std_ulogic;
      mosi  : in  std_ulogic;
      latch : in  std_ulogic;
      miso  : out std_ulogic;
      clr_n : in  std_ulogic;
      -- LUT outputs
      Qa    : out std_ulogic;
      Qb    : out std_ulogic;
      Qc    : out std_ulogic;
      Qd    : out std_ulogic;
      -- connection box ports
      cin    : in  std_ulogic;
      cout   : out std_ulogic;
      cb_w   : in  std_ulogic_vector(1 downto 0);
      cb_n   : in  std_ulogic_vector(3 downto 0);
      cb_s   : in  std_ulogic_vector(3 downto 0);
      cb_pre : in  std_ulogic_vector(3 downto 0)
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

  -- LUT outputs
  signal o_qa       : std_logic;
  signal o_qb       : std_logic;
  signal o_qc       : std_logic;
  signal o_qd       : std_logic;

  signal cin          : std_logic;
  signal cout         : std_logic;
  signal cb_bus_west  : std_ulogic_vector(1 downto 0);
  signal cb_bus_north : std_ulogic_vector(3 downto 0);
  signal cb_bus_south : std_ulogic_vector(3 downto 0);
  signal cb_presel    : std_ulogic_vector(3 downto 0);

  signal clk_count  : std_logic_vector(31 downto 0) := (others => '0');

  signal conf_done : std_logic := '0';
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
    file text_file : text open read_mode is "bitstream.txt";
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

    while not endfile(text_file) loop  
      readline(text_file, text_line);
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
    conf_done <= '1';
    wait;
    -- finish;
  end process;

  -- generate initial reset
  p_reset_gen : process
  begin 
    rst_n <= '0';
    wait until rising_edge(conf_done);
    wait for (CLK_PERIOD / 4);
    wait until rising_edge(clk);
    rst_n <= '1';
    wait;
  end process;

  p_test : process(clk)
  begin
    if unsigned(clk_count) = 0 then
      cb_presel <= "0000";
    end if;
    if unsigned(clk_count) = 2 then
      cb_presel <= "0001";
    end if;
    if unsigned(clk_count) = 3 then
      cb_presel <= "0010";
    end if;
    if unsigned(clk_count) = 4 then
      cb_presel <= "0011";
    end if;
    if unsigned(clk_count) = 5 then
      cb_presel <= "0100";
    end if;
    if unsigned(clk_count) = 6 then
      cb_presel <= "0101";
    end if;
    if unsigned(clk_count) = 7 then
      cb_presel <= "0110";
    end if;
    if unsigned(clk_count) = 8 then
      cb_presel <= "0111";
    end if;
    if unsigned(clk_count) = 9 then
      cb_presel <= "1000";
    end if;
    if unsigned(clk_count) = 10 then
      cb_presel <= "1001";
    end if;
    if unsigned(clk_count) = 11 then
      cb_presel <= "1010";
    end if;
    if unsigned(clk_count) = 12 then
      cb_presel <= "1011";
    end if;
    if unsigned(clk_count) = 13 then
      cb_presel <= "1100";
    end if;
    if unsigned(clk_count) = 14 then
      cb_presel <= "1101";
    end if;
    if unsigned(clk_count) = 15 then
      cb_presel <= "1110";
    end if;
    if unsigned(clk_count) = 16 then
      cb_presel <= "1111";
    end if;
  end process;

  clb_inst : clb_slice
    port map (
      -- clocking and reset
      clk_0 => clk,
      clk_1 => '0',
      rst_n => rst_n,
      -- configuration
      sclk  => sclk,
      mosi  => mosi,
      latch => latch,
      miso  => miso,
      clr_n => cfg_clr_n,
      -- LUT outputs
      Qa    => o_qa,
      Qb    => o_qb,
      Qc    => o_qc,
      Qd    => o_qd,
      -- connection box ports
      cin    => cin,
      cout   => cout,
      cb_w   => cb_bus_west,
      cb_n   => cb_bus_north,
      cb_s   => cb_bus_south,
      cb_pre => cb_presel
    );


end bh;
