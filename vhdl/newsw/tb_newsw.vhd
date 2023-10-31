library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_newsw is

end tb_newsw;

architecture bh of tb_newsw is

  component newsw is
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
  end component;

  constant CLK_PERIOD: TIME := 5 ns;

  signal clk        : std_logic;
  signal i_n  : std_logic := 'Z';
  signal i_s  : std_logic := 'U';
  signal i_e  : std_logic := 'X';
  signal i_w  : std_logic := 'Z';
  signal en_x : std_logic := '0';
  signal en_n : std_logic := '0';
  signal en_s : std_logic := '0';
  signal en_e : std_logic := '0';
  signal en_w : std_logic := '0';

  signal clk_count  : std_logic_vector(31 downto 0) := (others => '0');
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
    if unsigned(clk_count) = 0 then
      i_n <= '0';
    end if;

    -- all config signals must be asserted at the same time
    if unsigned(clk_count) = 1 then
      en_n <= '1';
      en_x <= '1';
      en_s <= '1';
      en_e <= '1';
    end if;
    if unsigned(clk_count) = 2 then
      --en_n <= '1';
      --en_x <= '1';
      --en_s <= '1';
      --en_e <= '1';
    end if;

    if unsigned(clk_count) = 5 then
      i_n <= '0';
    end if;
    if unsigned(clk_count) = 6 then
      i_n <= '1';
    end if;
    if unsigned(clk_count) = 7 then
      i_n <= '0';
    end if;
    if unsigned(clk_count) = 8 then
      i_n <= '1';
    end if;

  end process;

  newsw_inst : newsw
    port map (
      d_n  => i_n,
      d_s  => i_s,
      d_e  => i_e,
      d_w  => i_w,
      en_x => en_x,
      en_n => en_n,
      en_s => en_s,
      en_e => en_e,
      en_w => en_w
    );
end bh;

