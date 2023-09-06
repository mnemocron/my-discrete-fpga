
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_cbox is

end tb_cbox;

architecture bh of tb_cbox is

  component cbox is
    port(
      a  : inout std_logic;
      b  : inout std_logic;
      c  : in    std_logic;
      en : in    std_logic
    );
  end component;

  constant CLK_PERIOD: TIME := 5 ns;
  constant SPI_CLK_PERIOD: TIME := 1 ns;

  signal clk        : std_logic;
  signal rst_n      : std_logic;

  signal clk_count  : std_logic_vector(31 downto 0) := (others => '0');

  signal sa : std_logic := 'Z';
  signal sb : std_logic := 'Z';
  signal sc : std_logic := 'Z';
  signal en : std_logic := 'Z';
  signal a_is_driving : std_logic := '0';
  signal b_is_driving : std_logic := '0';
  signal c_is_driving : std_logic := '0';

begin

  -- generate clk signal
  p_clk_gen : process
  begin
   clk <= '1';
   wait for (CLK_PERIOD / 2);
   clk <= '0';
   wait for (CLK_PERIOD / 2);
   clk_count <= std_logic_vector(unsigned(clk_count) + 1);
  end process;

  p_test : process(clk)
  begin
    if unsigned(clk_count) = 1 then
      sa <= 'Z';
      sb <= 'Z';
      sc <= '0';
      en <= '0';
    end if;
    if unsigned(clk_count) = 2 then
      a_is_driving <= '1';
      sa <= '0';
    end if;
    if unsigned(clk_count) = 3 then
      sa <= '1';
    end if;
    if unsigned(clk_count) = 4 then
      sa <= '0';
    end if;
    if unsigned(clk_count) = 5 then
      sa <= '1';
    end if;
    if unsigned(clk_count) = 6 then
      a_is_driving <= '0';
      sa <= 'Z';
    end if;

    if unsigned(clk_count) = 10 then
      b_is_driving <= '1';
      sb <= '0';
    end if;
    if unsigned(clk_count) = 11 then
      sb <= '1';
    end if;
    if unsigned(clk_count) = 12 then
      sb <= '0';
    end if;
    if unsigned(clk_count) = 13 then
      b_is_driving <= '0';
      sb <= 'Z';
    end if;

    if unsigned(clk_count) = 20 then
      c_is_driving <= '1';
      en <= '1';
      sc <= '0';
    end if;
    if unsigned(clk_count) = 21 then
      sc <= '1';
    end if;
    if unsigned(clk_count) = 22 then
      sc <= '0';
    end if;
    if unsigned(clk_count) = 23 then
      c_is_driving <= '0';
      en <= '0';
      sc <= '0';
    end if;

  end process;

  cbox_inst : cbox 
    port map (
      a  => sa,
      b  => sb,
      c  => sc,
      en => en
    );

end bh;
