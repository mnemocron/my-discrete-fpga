----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-09-07
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

entity xpoint_thru is
  port(
    d_n  : inout std_logic;
    d_s  : inout std_logic;
    d_e  : inout std_logic;
    d_w  : inout std_logic;
    en_x : in    std_logic;
    en_n : in    std_logic;
    en_s : in    std_logic;
    en_e : in    std_logic;
    en_w : in    std_logic
  );
end entity;

architecture arch of xpoint_thru is
begin

    d_n <= d_s when (en_n = '1' and (d_s='0' or d_s='1') and en_s = '1') else
           d_e when (en_n = '1' and (d_e='0' or d_e='1') and en_e = '1' and en_x = '1') else
           d_w when (en_n = '1' and (d_w='0' or d_w='1') and en_w = '1' and en_x = '1') else 'Z';
    d_s <= d_n when (en_s = '1' and (d_n='0' or d_n='1') and en_n = '1') else
           d_e when (en_s = '1' and (d_e='0' or d_e='1') and en_e = '1' and en_x = '1') else
           d_w when (en_s = '1' and (d_w='0' or d_w='1') and en_w = '1' and en_x = '1') else 'Z';
    d_e <= d_w when (en_e = '1' and (d_w='0' or d_w='1') and en_w = '1') else
           d_n when (en_e = '1' and (d_n='0' or d_n='1') and en_n = '1' and en_x = '1') else
           d_s when (en_e = '1' and (d_s='0' or d_s='1') and en_s = '1' and en_x = '1') else 'Z';
    d_w <= d_e when (en_w = '1' and (d_e='0' or d_e='1') and en_e = '1') else
           d_n when (en_w = '1' and (d_n='0' or d_n='1') and en_n = '1' and en_x = '1') else
           d_s when (en_w = '1' and (d_s='0' or d_s='1') and en_s = '1' and en_x = '1') else 'Z';

end architecture;
