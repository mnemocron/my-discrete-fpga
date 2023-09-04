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
end entity;

architecture arch of sr_74xx595 is
  signal reg_internal : std_ulogic_vector(7 downto 0) := (others => 'U');
  signal reg_latch    : std_ulogic_vector(7 downto 0) := (others => 'U');
begin
  p_reg_int : process(srclk)
  begin
    if rising_edge(srclk) then
      if srclkr_n = '0' then
        reg_internal <= (others => '0');
      else
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
