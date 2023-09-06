----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-09-03
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
-- use ieee.numeric_std.all;

entity sr_74xx595 is
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
end entity;

architecture arch of sr_74xx595 is
  signal reg_internal : std_logic_vector(7 downto 0) := (others => 'U');
  signal reg_latch    : std_logic_vector(7 downto 0) := (others => 'U');
begin
  p_reg_int : process(srclk,srclkr_n)
  begin
    -- asynchronous clear
    if srclkr_n = '0' then
      reg_internal <= (others => '0');
    else
      if rising_edge(srclk) then
        reg_internal(7 downto 1) <= reg_internal(6 downto 0);
        reg_internal(0) <= ser;
      end if;
    end if;
  end process;

  p_latch : process(rclk)
  begin
    if rising_edge(rclk) then
      reg_latch <= reg_internal;
    end if;
  end process;

  qa <= reg_latch(0) when oe_n = '0' else 'Z';
  qb <= reg_latch(1) when oe_n = '0' else 'Z';
  qc <= reg_latch(2) when oe_n = '0' else 'Z';
  qd <= reg_latch(3) when oe_n = '0' else 'Z';
  qe <= reg_latch(4) when oe_n = '0' else 'Z';
  qf <= reg_latch(5) when oe_n = '0' else 'Z';
  qg <= reg_latch(6) when oe_n = '0' else 'Z';
  qh <= reg_latch(7) when oe_n = '0' else 'Z';
  qh_s <= reg_internal(7);

end architecture;
