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

entity digital_switch is
    port(
        en : in    std_ulogic;
        d1 : inout std_ulogic;
        d2 : inout std_ulogic
    );
end entity;

architecture arch of digital_switch is
begin

    d1 <= '1' when (d2 = '1' and en = '1') else
          '0' when (d2 = '0' and en = '1') else 'Z';

    d2 <= '1' when (d1 = '1' and en = '0') else
          '0' when (d1 = '0' and en = '0') else 'Z';

end architecture;
