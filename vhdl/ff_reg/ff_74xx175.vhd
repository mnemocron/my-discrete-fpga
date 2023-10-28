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
    clk    : in  std_logic;
    arst_n : in  std_logic;
    din    : in  std_logic_vector(7 downto 0);
    qout   : out std_logic_vector(7 downto 0);
    qout_n : out std_logic_vector(7 downto 0)
  );
end entity;

architecture arch of ff_74xx175 is
    
begin
  p_reg : process(arst_n, clk)
  begin
    if arst_n = '0' then -- asynchronous / active low
      qout   <= (others => '0');
      qout_n <= (others => '1');
    elsif rising_edge(clk) then
      qout   <= din;
      qout_n <= not din;
    end if;
  end process;

end architecture;
