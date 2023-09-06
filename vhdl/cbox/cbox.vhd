
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cbox is
  port(
    a  : inout std_logic;
    b  : inout std_logic;
    c  : in    std_logic;
    en : in    std_logic
  );
end entity;

architecture arch of cbox is

  signal direction : std_logic;

begin

  b <= c when en = '1' else
      '0' when a = '0' else
      '1' when a = '1' else 'Z';

  a <= c when en = '1' else
      '0' when b = '0' else
      '1' when b = '1' else 'Z';

end architecture;
