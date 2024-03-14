
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bus_io_dummy is
  port(
    -- bus interfaces
    bus_a  : inout std_logic_vector(5 downto 0);
    bus_b  : inout std_logic_vector(5 downto 0)
  );
end entity;

architecture dummy_arch of bus_io_dummy is
begin
  bus_a(0) <= '0' when bus_b(0) = '0' else 
              '1' when bus_b(0) = '1' else 'Z';
  bus_a(1) <= '0' when bus_b(1) = '0' else 
              '1' when bus_b(1) = '1' else 'Z';
  bus_a(2) <= '0' when bus_b(2) = '0' else 
              '1' when bus_b(2) = '1' else 'Z';
  bus_a(3) <= '0' when bus_b(3) = '0' else 
              '1' when bus_b(3) = '1' else 'Z';
  bus_a(4) <= '0' when bus_b(4) = '0' else 
              '1' when bus_b(4) = '1' else 'Z';
  bus_a(5) <= '0' when bus_b(5) = '0' else 
              '1' when bus_b(5) = '1' else 'Z';

  bus_b(0) <= '0' when bus_a(0) = '0' else 
              '1' when bus_a(0) = '1' else 'Z';
  bus_b(1) <= '0' when bus_a(1) = '0' else 
              '1' when bus_a(1) = '1' else 'Z';
  bus_b(2) <= '0' when bus_a(2) = '0' else 
              '1' when bus_a(2) = '1' else 'Z';
  bus_b(3) <= '0' when bus_a(3) = '0' else 
              '1' when bus_a(3) = '1' else 'Z';
  bus_b(4) <= '0' when bus_a(4) = '0' else 
              '1' when bus_a(4) = '1' else 'Z';
  bus_b(5) <= '0' when bus_a(5) = '0' else 
              '1' when bus_a(5) = '1' else 'Z';
end architecture;
