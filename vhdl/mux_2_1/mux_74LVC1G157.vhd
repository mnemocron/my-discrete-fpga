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

entity mux_74LVC1G157 is
    port(
        s   : in  std_ulogic;
        e_n : in  std_ulogic;
        i0  : in  std_ulogic;
        i1  : in  std_ulogic;
        y   : out std_ulogic
    );
end entity;

architecture arch of mux_74LVC1G157 is
    signal yy : std_ulogic;
begin

    yy <= i0 when s = '0' else
          i1 when s = '1' else 'Z';

    y <= yy when e_n = '0' else '0';

end architecture;
