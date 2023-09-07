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

entity xpoint_double_thru is
  port(
    d_n  : inout std_logic_vector(1 downto 0);
    d_s  : inout std_logic_vector(1 downto 0);
    d_e  : inout std_logic_vector(1 downto 0);
    d_w  : inout std_logic_vector(1 downto 0);
    x_ne : in    std_logic;
    x_nw : in    std_logic;
    x_se : in    std_logic;
    x_sw : in    std_logic;
    en_n : in    std_logic_vector(1 downto 0);
    en_s : in    std_logic_vector(1 downto 0);
    en_e : in    std_logic_vector(1 downto 0);
    en_w : in    std_logic_vector(1 downto 0)
  );
end entity;

architecture arch of xpoint_double_thru is
begin

  d_n(0) <= d_s(0) when (en_n(0) = '1' and en_s(0) = '1' and (d_s(0) = '0' or d_s(0) = '1')) else
            d_e(0) when (en_n(0) = '1' and en_e(0) = '1' and (d_e(0) = '0' or d_e(0) = '1') and x_se = '1') else
            d_e(1) when (en_n(0) = '1' and en_e(1) = '1' and (d_e(1) = '0' or d_e(1) = '1') and x_ne = '1') else
            d_w(0) when (en_n(0) = '1' and en_w(0) = '1' and (d_w(0) = '0' or d_w(0) = '1') and x_se = '1') else
            d_w(1) when (en_n(0) = '1' and en_w(1) = '1' and (d_w(1) = '0' or d_w(1) = '1') and x_ne = '1') else 'Z';

  d_n(1) <= d_s(1) when (en_n(1) = '1' and en_s(1) = '1' and (d_s(1) = '0' or d_s(1) = '1')) else
            d_e(0) when (en_n(1) = '1' and en_e(0) = '1' and (d_e(0) = '0' or d_e(0) = '1') and x_sw = '1') else
            d_e(1) when (en_n(1) = '1' and en_e(1) = '1' and (d_e(1) = '0' or d_e(1) = '1') and x_nw = '1') else
            d_w(0) when (en_n(1) = '1' and en_w(0) = '1' and (d_w(0) = '0' or d_w(0) = '1') and x_se = '1') else
            d_w(1) when (en_n(1) = '1' and en_w(1) = '1' and (d_w(1) = '0' or d_w(1) = '1') and x_ne = '1') else 'Z';

  d_s(0) <= d_n(0) when (en_s(0) = '1' and en_n(0) = '1' and (d_n(0) = '0' or d_n(0) = '1')) else
            d_e(0) when (en_s(0) = '1' and en_e(0) = '1' and (d_e(0) = '0' or d_e(0) = '1') and x_se = '1') else
            d_e(1) when (en_s(0) = '1' and en_e(1) = '1' and (d_e(1) = '0' or d_e(1) = '1') and x_ne = '1') else
            d_w(0) when (en_s(0) = '1' and en_w(0) = '1' and (d_w(0) = '0' or d_w(0) = '1') and x_se = '1') else
            d_w(1) when (en_s(0) = '1' and en_w(1) = '1' and (d_w(1) = '0' or d_w(1) = '1') and x_ne = '1') else 'Z';

  d_s(1) <= d_n(1) when (en_s(1) = '1' and en_n(1) = '1' and (d_n(1) = '0' or d_n(1) = '1')) else
            d_e(0) when (en_s(1) = '1' and en_e(0) = '1' and (d_e(0) = '0' or d_e(0) = '1') and x_sw = '1') else
            d_e(1) when (en_s(1) = '1' and en_e(1) = '1' and (d_e(1) = '0' or d_e(1) = '1') and x_nw = '1') else
            d_w(0) when (en_s(1) = '1' and en_w(0) = '1' and (d_w(0) = '0' or d_w(0) = '1') and x_sw = '1') else
            d_w(1) when (en_s(1) = '1' and en_w(1) = '1' and (d_w(1) = '0' or d_w(1) = '1') and x_nw = '1') else 'Z';

  d_e(0) <= d_w(0) when (en_e(0) = '1' and en_w(0) = '1' and (d_w(0) = '0' or d_w(0) = '1')) else
            d_n(0) when (en_e(0) = '1' and en_n(0) = '1' and (d_n(0) = '0' or d_n(0) = '1') and x_se = '1') else
            d_n(1) when (en_e(0) = '1' and en_n(1) = '1' and (d_n(1) = '0' or d_n(1) = '1') and x_sw = '1') else
            d_s(0) when (en_e(0) = '1' and en_s(0) = '1' and (d_s(0) = '0' or d_s(0) = '1') and x_se = '1') else
            d_s(1) when (en_e(0) = '1' and en_s(1) = '1' and (d_s(1) = '0' or d_s(1) = '1') and x_sw = '1') else 'Z';

  d_e(1) <= d_w(1) when (en_e(1) = '1' and en_w(1) = '1' and (d_w(1) = '0' or d_w(1) = '1')) else
            d_n(0) when (en_e(1) = '1' and en_n(0) = '1' and (d_n(0) = '0' or d_n(0) = '1') and x_ne = '1') else
            d_n(1) when (en_e(1) = '1' and en_n(1) = '1' and (d_n(1) = '0' or d_n(1) = '1') and x_nw = '1') else
            d_s(0) when (en_e(1) = '1' and en_s(0) = '1' and (d_s(0) = '0' or d_s(0) = '1') and x_ne = '1') else
            d_s(1) when (en_e(1) = '1' and en_s(1) = '1' and (d_s(1) = '0' or d_s(1) = '1') and x_nw = '1') else 'Z';

  d_w(0) <= d_e(0) when (en_w(0) = '1' and en_e(0) = '1' and (d_e(0) = '0' or d_e(0) = '1')) else
            d_n(0) when (en_w(0) = '1' and en_n(0) = '1' and (d_n(0) = '0' or d_n(0) = '1') and x_se = '1') else
            d_n(1) when (en_w(0) = '1' and en_n(1) = '1' and (d_n(1) = '0' or d_n(1) = '1') and x_sw = '1') else
            d_s(0) when (en_w(0) = '1' and en_s(0) = '1' and (d_s(0) = '0' or d_s(0) = '1') and x_se = '1') else
            d_s(1) when (en_w(0) = '1' and en_s(1) = '1' and (d_s(1) = '0' or d_s(1) = '1') and x_sw = '1') else 'Z';

  d_w(1) <= d_e(1) when (en_w(1) = '1' and en_e(1) = '1' and (d_e(1) = '0' or d_e(1) = '1')) else
            d_n(0) when (en_w(1) = '1' and en_n(0) = '1' and (d_n(0) = '0' or d_n(0) = '1') and x_ne = '1') else
            d_n(1) when (en_w(1) = '1' and en_n(1) = '1' and (d_n(1) = '0' or d_n(1) = '1') and x_nw = '1') else
            d_s(0) when (en_w(1) = '1' and en_s(0) = '1' and (d_s(0) = '0' or d_s(0) = '1') and x_ne = '1') else
            d_s(1) when (en_w(1) = '1' and en_s(1) = '1' and (d_s(1) = '0' or d_s(1) = '1') and x_nw = '1') else 'Z';



end architecture;
