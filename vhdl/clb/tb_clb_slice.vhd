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
-- Revision:       1.0.0
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
  signal sum_out    : std_logic_vector(3 downto 0);

  signal cin          : std_logic;
  signal cout         : std_logic;
  signal cb_bus_west  : std_logic_vector(3 downto 0);
  signal cb_bus_north : std_logic_vector(3 downto 0);
  signal cb_bus_south : std_logic_vector(3 downto 0);
  signal cb_presel    : std_logic_vector(3 downto 0);
  signal lut_input    : std_logic_vector(3 downto 0);

  signal clk_count  : std_logic_vector(31 downto 0) := (others => '0');

  signal bitstream_done : std_logic := '0';
  signal test_done : std_logic := '0';
begin

  lut_input <= cb_presel;

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
    file bitstream_sum_file : text open read_mode is "bitstream_carry.txt";
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
    bitstream_done <= '0';
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

    while not endfile(bitstream_sum_file) loop  
      readline(bitstream_sum_file, text_line);
      -- skip empty and comment lines
      if text_line.all'length = 0 or text_line.all(1) = '#' then
        next;
      end if;
      read(text_line, conf_byte, ok);
      assert ok
        report "Read 'conf_byte' failed for line: " & text_line.all
        severity failure;

      l_send_byte_2 : for k in conf_byte'length-1 downto 0 loop
        mosi <= conf_byte(k);
        wait for (SPI_CLK_PERIOD / 2);
        sclk <= '1';
        wait for (SPI_CLK_PERIOD / 2);
        sclk <= '0';
      end loop l_send_byte_2;
    end loop;

    wait for 5 ns;
    latch <= '1';
    wait for 5 ns;
    latch <= '0';
    wait for 5 ns;
    bitstream_done <= '1';

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
    if unsigned(clk_count) = 0 then
      cb_presel <= (others => '0');
      cb_presel <= (others => '0');
      cb_bus_north <= (others => '0');
      cb_bus_south <= (others => '0');
      cb_bus_west  <= (others => '0');
      cin <= '0';
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
    if unsigned(clk_count) = 17 then
      cb_presel <= "0000";
    end if;

    if (unsigned(clk_count) > 31+16) and (unsigned(clk_count) < (31+256+16)) then
      cb_bus_north <= std_logic_vector(clk_count(3 downto 0));
      cb_bus_south <= std_logic_vector(clk_count(7 downto 4));
      cin <= '0';
    end if;
    if (unsigned(clk_count) > 31+256+16) and (unsigned(clk_count) < (31+256+256+16)) then
      cb_bus_north <= std_logic_vector(clk_count(3 downto 0));
      cb_bus_south <= std_logic_vector(clk_count(7 downto 4));
      cin <= '1';
    end if;

    if unsigned(clk_count) = 563 then
      cb_bus_north <= "0000";
      cb_bus_north <= "0000";
      cin <= '0';
    end if;
    if unsigned(clk_count) = 564 then
      cb_bus_north <= "0101";
      cb_bus_north <= "0010";
      cin <= '0';
    end if;
    if unsigned(clk_count) = 565 then
      cb_bus_north <= "0000";
      cb_bus_north <= "0000";
      cin <= '0';
    end if;
    if unsigned(clk_count) = 566 then
      cb_bus_north <= "0101";
      cb_bus_north <= "0010";
      cin <= '1';
    end if;
    if unsigned(clk_count) = 567 then
      cb_bus_north <= "0000";
      cb_bus_north <= "0000";
      cin <= '0';
    end if;



  end process;

  p_assert : process(clk)
  begin
    if falling_edge(clk) then -- falling edge because of signal changes on rising edge
      if unsigned(clk_count) = 2 then
        assert o_qa = '0' report "(2) Qa != 0 - instead=" & std_logic'image(o_qa);
        assert o_qb = '0' report "(2) Qb != 0 - instead=" & std_logic'image(o_qb);
        assert o_qc = '0' report "(2) Qc != 0 - instead=" & std_logic'image(o_qc);
        assert o_qd = '1' report "(2) Qc != 1 - instead=" & std_logic'image(o_qd);
      end if;
      if unsigned(clk_count) = 3 then
        assert o_qa = '1' report "(3) Qa != 1 - instead=" & std_logic'image(o_qa);
        assert o_qb = '0' report "(3) Qb != 0 - instead=" & std_logic'image(o_qb);
        assert o_qc = '1' report "(3) Qc != 1 - instead=" & std_logic'image(o_qc);
        assert o_qd = '1' report "(3) Qc != 1 - instead=" & std_logic'image(o_qd);
      end if;
      if unsigned(clk_count) = 4 then
        assert o_qa = '1' report "(4) Qa != 1 - instead=" & std_logic'image(o_qa);
        assert o_qb = '0' report "(4) Qb != 0 - instead=" & std_logic'image(o_qb);
        assert o_qc = '1' report "(4) Qc != 1 - instead=" & std_logic'image(o_qc);
        assert o_qd = '1' report "(4) Qc != 1 - instead=" & std_logic'image(o_qd);
      end if;
      if unsigned(clk_count) = 5 then
        assert o_qa = '0' report "(5) Qa != 0 - instead=" & std_logic'image(o_qa);
        assert o_qb = '0' report "(5) Qb != 0 - instead=" & std_logic'image(o_qb);
        assert o_qc = '0' report "(5) Qc != 0 - instead=" & std_logic'image(o_qc);
        assert o_qd = '0' report "(5) Qc != 0 - instead=" & std_logic'image(o_qd);
      end if;
      if unsigned(clk_count) = 6 then
        assert o_qa = '1' report "(6) Qa != 1 - instead=" & std_logic'image(o_qa);
        assert o_qb = '0' report "(6) Qb != 0 - instead=" & std_logic'image(o_qb);
        assert o_qc = '1' report "(6) Qc != 1 - instead=" & std_logic'image(o_qc);
        assert o_qd = '1' report "(6) Qc != 1 - instead=" & std_logic'image(o_qd);
      end if;
      if unsigned(clk_count) = 7 then
        assert o_qa = '0' report "(7) Qa != 0 - instead=" & std_logic'image(o_qa);
        assert o_qb = '0' report "(7) Qb != 0 - instead=" & std_logic'image(o_qb);
        assert o_qc = '0' report "(7) Qc != 0 - instead=" & std_logic'image(o_qc);
        assert o_qd = '1' report "(7) Qc != 1 - instead=" & std_logic'image(o_qd);
      end if;
      if unsigned(clk_count) = 8 then
        assert o_qa = '0' report "(8) Qa != 0 - instead=" & std_logic'image(o_qa);
        assert o_qb = '0' report "(8) Qb != 0 - instead=" & std_logic'image(o_qb);
        assert o_qc = '0' report "(8) Qc != 0 - instead=" & std_logic'image(o_qc);
        assert o_qd = '1' report "(8) Qc != 1 - instead=" & std_logic'image(o_qd);
      end if;
      if unsigned(clk_count) = 9 then
        assert o_qa = '0' report "(9) Qa != 0 - instead=" & std_logic'image(o_qa);
        assert o_qb = '0' report "(9) Qb != 0 - instead=" & std_logic'image(o_qb);
        assert o_qc = '1' report "(9) Qc != 1 - instead=" & std_logic'image(o_qc);
        assert o_qd = '0' report "(9) Qc != 0 - instead=" & std_logic'image(o_qd);
      end if;
      if unsigned(clk_count) = 10 then
        assert o_qa = '1' report "(10) Qa != 1 - instead=" & std_logic'image(o_qa);
        assert o_qb = '0' report "(10) Qb != 0 - instead=" & std_logic'image(o_qb);
        assert o_qc = '1' report "(10) Qc != 1 - instead=" & std_logic'image(o_qc);
        assert o_qd = '1' report "(10) Qc != 1 - instead=" & std_logic'image(o_qd);
      end if;
      if unsigned(clk_count) = 11 then
        assert o_qa = '0' report "(11) Qa != 0 - instead=" & std_logic'image(o_qa);
        assert o_qb = '0' report "(11) Qb != 0 - instead=" & std_logic'image(o_qb);
        assert o_qc = '0' report "(11) Qc != 0 - instead=" & std_logic'image(o_qc);
        assert o_qd = '1' report "(11) Qc != 1 - instead=" & std_logic'image(o_qd);
      end if;
      if unsigned(clk_count) = 12 then
        assert o_qa = '0' report "(12) Qa != 0 - instead=" & std_logic'image(o_qa);
        assert o_qb = '0' report "(12) Qb != 0 - instead=" & std_logic'image(o_qb);
        assert o_qc = '0' report "(12) Qc != 0 - instead=" & std_logic'image(o_qc);
        assert o_qd = '1' report "(12) Qc != 1 - instead=" & std_logic'image(o_qd);
      end if;
      if unsigned(clk_count) = 13 then
        assert o_qa = '0' report "(13) Qa != 0 - instead=" & std_logic'image(o_qa);
        assert o_qb = '0' report "(13) Qb != 0 - instead=" & std_logic'image(o_qb);
        assert o_qc = '1' report "(13) Qc != 1 - instead=" & std_logic'image(o_qc);
        assert o_qd = '0' report "(13) Qc != 0 - instead=" & std_logic'image(o_qd);
      end if;
      if unsigned(clk_count) = 14 then
        assert o_qa = '0' report "(14) Qa != 0 - instead=" & std_logic'image(o_qa);
        assert o_qb = '0' report "(14) Qb != 0 - instead=" & std_logic'image(o_qb);
        assert o_qc = '0' report "(14) Qc != 0 - instead=" & std_logic'image(o_qc);
        assert o_qd = '1' report "(14) Qc != 1 - instead=" & std_logic'image(o_qd);
      end if;
      if unsigned(clk_count) = 15 then
        assert o_qa = '0' report "(15) Qa != 0 - instead=" & std_logic'image(o_qa);
        assert o_qb = '0' report "(15) Qb != 0 - instead=" & std_logic'image(o_qb);
        assert o_qc = '1' report "(15) Qc != 1 - instead=" & std_logic'image(o_qc);
        assert o_qd = '1' report "(15) Qc != 1 - instead=" & std_logic'image(o_qd);
      end if;
      if unsigned(clk_count) = 16 then
        assert o_qa = '0' report "(16) Qa != 0 - instead=" & std_logic'image(o_qa);
        assert o_qb = '0' report "(16) Qb != 0 - instead=" & std_logic'image(o_qb);
        assert o_qc = '1' report "(16) Qc != 1 - instead=" & std_logic'image(o_qc);
        assert o_qd = '1' report "(16) Qc != 1 - instead=" & std_logic'image(o_qd);
      end if;
      if unsigned(clk_count) = 17 then
        assert o_qa = '0' report "(17) Qa != 0 - instead=" & std_logic'image(o_qa);
        assert o_qb = '1' report "(17) Qb != 1 - instead=" & std_logic'image(o_qb);
        assert o_qc = '0' report "(17) Qc != 0 - instead=" & std_logic'image(o_qc);
        assert o_qd = '0' report "(17) Qc != 0 - instead=" & std_logic'image(o_qd);
      end if;
      if unsigned(clk_count) = 20 then
        test_done <= '1';
      end if;
    end if;
  end process;

  sum_out(3) <= o_qd;
  sum_out(2) <= o_qc;
  sum_out(1) <= o_qb;
  sum_out(0) <= o_qa;

  clb_inst : clb_slice
    port map (
      -- clocking and reset
      clk_0 => '0',
      clk_1 => clk,
      rst_n => rst_n,
      -- configuration
      sclk  => sclk,
      mosi  => mosi,
      latch => latch,
      miso  => miso,
      clr_n => cfg_clr_n,
      ce    => '0',
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
