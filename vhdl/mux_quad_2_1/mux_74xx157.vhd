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

entity mux_74xx157 is
    port(
        s    : in  std_logic;
        e_n  : in  std_logic;
        in_0 : in  std_logic_vector(3 downto 0);
        in_1 : in  std_logic_vector(3 downto 0);
        y    : out std_logic_vector(3 downto 0)
    );
end entity;

architecture arch of mux_74xx157 is
    signal yy : std_logic_vector(3 downto 0);
begin
    
    -- the 74xx157 does NOT have a tri-state output (only the 74xx257)

    yy <= in_1 when s = '1' else
         in_0;

    y <= yy when e_n = '0' else "0000";

end architecture;
