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

entity ff_74xx175 is
  port(
    clk    : in  std_ulogic;
    rst_n  : in  std_ulogic;
    din    : in  std_ulogic_vector(7 downto 0);
    qout   : out std_ulogic_vector(7 downto 0);
    qout_n : out std_ulogic_vector(7 downto 0)
  );
end entity;

architecture arch of ff_74xx175 is
    
begin
  p_reg : process(clk)
  begin
    if rising_edge(clk) then
      if rst_n = '0' then
        qout   <= (others => '0');
        qout_n <= (others => '1');
      else
        qout   <= din;
        qout_n <= not din;
      end if;
    end if;
  end process;

end architecture;
