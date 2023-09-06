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

entity mux_74xx151 is
    port(
        s    : in  std_logic_vector(2 downto 0);
        e_n  : in  std_logic;
        i    : in  std_logic_vector(7 downto 0);
        y    : out std_logic
    );
end entity;

architecture arch of mux_74xx151 is
  signal yy : std_logic;
begin
    
    -- the 74xx151 does NOT have a tri-state output (only the 74xx251)

    yy <= i(7) when s = "111" else
          i(6) when s = "110" else
          i(5) when s = "101" else
          i(4) when s = "100" else
          i(3) when s = "011" else
          i(2) when s = "010" else
          i(1) when s = "001" else
          i(0);
          
    y <= yy when e_n = '0' else '0';

end architecture;
