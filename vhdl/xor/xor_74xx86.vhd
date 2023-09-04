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

entity xor_74xx86 is
  port(
    a : in  std_ulogic_vector(3 downto 0);
    b : in  std_ulogic_vector(3 downto 0);  
    y : out std_ulogic_vector(3 downto 0)
  );
end entity;

architecture arch of xor_74xx86 is
begin
  y(0) <= a(0) xor b(0);
  y(1) <= a(1) xor b(1);
  y(2) <= a(2) xor b(2);
  y(3) <= a(3) xor b(3);
end architecture;
