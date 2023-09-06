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

entity mux_74xx153 is
    port(
        s    : in  std_logic_vector(1 downto 0);
        e1_n : in  std_logic;
        e2_n : in  std_logic;
        i1   : in  std_logic_vector(3 downto 0);
        i2   : in  std_logic_vector(3 downto 0);
        y1   : out std_logic;
        y2   : out std_logic
    );
end entity;

architecture arch of mux_74xx153 is
  signal yy1 : std_logic;
  signal yy2 : std_logic;
begin

    yy1 <= i1(3) when s = "11" else
           i1(2) when s = "10" else
           i1(1) when s = "01" else
           i1(0);

    yy2 <= i2(3) when s = "11" else
           i2(2) when s = "10" else
           i2(1) when s = "01" else
           i2(0);
          
    y1 <= yy1 when e1_n = '0' else '0';
    y2 <= yy2 when e2_n = '0' else '0';

end architecture;
