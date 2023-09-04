----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-09-03
-- Design Name:    tb_sr_74xx595
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

entity tb_sr_74xx595 is

end tb_sr_74xx595;

architecture bh of tb_sr_74xx595 is

  component sr_74xx595 is
    port(
      rclk     : in  std_ulogic; -- register latch clock
      srclk    : in  std_ulogic; -- serial clock
      srclkr_n : in  std_ulogic; -- register clear
      oe_n     : in  std_ulogic; 
      ser      : in  std_ulogic;
      qa       : out std_ulogic;
      qb       : out std_ulogic;
      qc       : out std_ulogic;
      qd       : out std_ulogic;
      qe       : out std_ulogic;
      qf       : out std_ulogic;
      qg       : out std_ulogic;
      qh       : out std_ulogic;
      qh_s     : out std_ulogic
    );
  end component;

  constant CLK_PERIOD: TIME := 5 ns;

  signal clk        : std_logic;
  signal sclk       : std_logic;
  signal rst_n      : std_logic;

  signal mosi  : std_ulogic := 'Z';
  signal miso  : std_ulogic := 'Z';
  signal ser_next : std_ulogic := 'Z';
  signal latch : std_ulogic := 'Z';
  signal q_a,q_b,q_c,q_d,q_e,q_f,q_g,q_h : std_ulogic := 'Z';
  signal x_a,x_b,x_c,x_d,x_e,x_f,x_g,x_h : std_ulogic := 'Z';

  signal send_data : std_ulogic_vector(15 downto 0) := (others => 'U');

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

  sclk <= clk;

  -- generate initial reset
  p_reset_gen : process
  begin 
    rst_n <= '0';
    wait until rising_edge(clk);
    wait for (CLK_PERIOD / 4);
    rst_n <= '1';
    wait;
  end process;

  send_data <= x"F0A5";

  p_test : process(clk)
  begin
    if rising_edge(clk) then
      if unsigned(clk_count) = 1 then
        latch <= '0';
        mosi <= '0';
      end if;
      if unsigned(clk_count) = 3 then
        latch <= '1';
      end if;
      if unsigned(clk_count) = 4 then
        latch <= '0';
      end if;

      if unsigned(clk_count) > 9 then
        if unsigned(clk_count) < 26 then
          mosi <= send_data( to_integer(15-(unsigned(clk_count)-10)) );
        end if;
      end if;

      if unsigned(clk_count) = 26 then
        latch <= '1';
      end if;
      if unsigned(clk_count) = 27 then
        latch <= '0';
      end if;
    end if;
  end process;

  p_assert : process(clk)
  begin
    if rising_edge(clk) then
      if unsigned(clk_count) = 5 then
        -- assert rx = x"00" report "rx != tx (0)";
      end if;
    end if;
  end process;

  reg_inst_0 : sr_74xx595
    port map (
      rclk     => latch,
      srclk    => sclk, 
      srclkr_n => rst_n, 
      oe_n     => '0', 
      ser      => mosi, 
      qa       => q_a, 
      qb       => q_b, 
      qc       => q_c, 
      qd       => q_d, 
      qe       => q_e, 
      qf       => q_f, 
      qg       => q_g, 
      qh       => q_h, 
      qh_s     => ser_next
    );

  reg_inst_1 : sr_74xx595
    port map (
      rclk     => latch,
      srclk    => sclk, 
      srclkr_n => rst_n, 
      oe_n     => '0', 
      ser      => ser_next, 
      qa       => x_a, 
      qb       => x_b, 
      qc       => x_c, 
      qd       => x_d, 
      qe       => x_e, 
      qf       => x_f, 
      qg       => x_g, 
      qh       => x_h, 
      qh_s     => miso
    );

end bh;
