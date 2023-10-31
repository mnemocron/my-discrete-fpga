
library ieee;
use ieee.std_logic_1164.all;

entity newsw is
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

architecture arch of newsw is
  signal conf_done : std_logic := '0';
  signal drv_done : std_logic := '0';
  signal drv_n : std_logic := '0';
  signal drv_s : std_logic := '0';
  signal drv_e : std_logic := '0';
  signal drv_w : std_logic := '0';
begin

  p_detect_config : process(en_x,en_n,en_s,en_w,en_e)
  begin
   if rising_edge(en_x) or rising_edge(en_n) or rising_edge(en_s) or rising_edge(en_e) or rising_edge(en_w) then
     conf_done <= '1';
   end if;
  end process;

  p_detect_drv : process(conf_done)
  begin
   if rising_edge(conf_done) then
    if(en_n = '1')then
      if(d_n = '1' or d_n = '0') then
        drv_n <= '1';
      end if;
    end if;
    
    if(en_s = '1')then
      if(d_s = '1' or d_s = '0') then
        drv_s <= '1';
      end if;
    end if;

    if(en_e = '1')then
      if(d_e = '1' or d_e = '0') then
        drv_e <= '1';
      end if;
    end if;

    if(en_w = '1')then
      if(d_w = '1' or d_w = '0') then
        drv_w <= '1';
      end if;
    end if;
    drv_done <= '1';
   end if;
  end process;

  p_assert_drv : process(drv_done)
  begin
    if rising_edge(drv_done) then
      assert ((drv_n and drv_s) = '0') report "N and S are driving each other";
      assert ((drv_e and drv_w) = '0') report "E and W are driving each other";
      if (en_x = '1') then
        assert ((drv_n and drv_e) = '0') report "N and E are driving each other in x mode";
        assert ((drv_n and drv_w) = '0') report "N and W are driving each other in x mode";
        assert ((drv_s and drv_e) = '0') report "S and E are driving each other in x mode";
        assert ((drv_s and drv_w) = '0') report "S and W are driving each other in x mode";
      end if;
    end if;
  end process;

      d_n <= d_s when (en_n = '1' and drv_s = '1') else
             d_e when (en_n = '1' and drv_e = '1' and en_x = '1') else
             d_w when (en_n = '1' and drv_w = '1' and en_x = '1') else 'Z';

      d_s <= d_n when (en_s = '1' and drv_n = '1') else
             d_e when (en_s = '1' and drv_e = '1' and en_x = '1') else
             d_w when (en_s = '1' and drv_w = '1' and en_x = '1') else 'Z';

      d_e <= d_w when (en_e = '1' and drv_w = '1') else
             d_n when (en_e = '1' and drv_n = '1' and en_x = '1') else
             d_s when (en_e = '1' and drv_s = '1' and en_x = '1') else 'Z';

      d_w <= d_e when (en_w = '1' and drv_e = '1') else
             d_n when (en_w = '1' and drv_n = '1' and en_x = '1') else
             d_s when (en_w = '1' and drv_s = '1' and en_x = '1') else 'Z';

end architecture;

