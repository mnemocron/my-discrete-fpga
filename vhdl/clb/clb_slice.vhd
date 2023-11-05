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
-- Revision:       1.0.0
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clb_slice is
  port(
    -- clocking and reset
    clk_0 : in  std_logic;
    clk_1 : in  std_logic;
    rst_n : in  std_logic;
    -- configuration
    sclk  : in  std_logic;
    mosi  : in  std_logic;
    latch : in  std_logic;
    miso  : out std_logic;
    clr_n   : in  std_logic;
    -- LUT outputs
    Qa    : out std_logic;
    Qb    : out std_logic;
    Qc    : out std_logic;
    Qd    : out std_logic;
    -- connection box ports
    cin    : in  std_logic;
    cout   : out std_logic;
    cb_w   : in  std_logic_vector(3 downto 0);
    cb_n   : in  std_logic_vector(3 downto 0);
    cb_s   : in  std_logic_vector(3 downto 0);
    cb_pre : in  std_logic_vector(3 downto 0)
  );
end entity;

architecture arch of clb_slice is

  -- D-type Flip Flop Register
  component ff_74xx175 is
    port(
      clk    : in  std_logic;
      arst_n : in  std_logic;
      din    : in  std_logic_vector(7 downto 0);
      qout   : out std_logic_vector(7 downto 0);
      qout_n : out std_logic_vector(7 downto 0)
    );
  end component;

  -- MUX 2:1
  component mux_74LVC1G157 is
    port(
      s   : in  std_logic;
      e_n : in  std_logic;
      i0  : in  std_logic;
      i1  : in  std_logic;
      y   : out std_logic
    );
  end component;

  -- MUX 4:1 (dual)
  component mux_74xx153 is
    port(
      s    : in  std_logic_vector(1 downto 0);
      e1_n : in  std_logic;
      e2_n : in  std_logic;
      i1   : in  std_logic_vector(3 downto 0);
      i2   : in  std_logic_vector(3 downto 0);
      y1   : out std_logic;
      y2   : out std_logic
    );
  end component;

  -- MUX 8:1
  component mux_74xx151 is
    port(
      s    : in  std_logic_vector(2 downto 0);
      e_n  : in  std_logic;
      i    : in  std_logic_vector(7 downto 0);
      y    : out std_logic
    );
  end component;

  -- MUX 2:1 (quad)
  component mux_74xx157 is
    port(
      s    : in  std_logic;
      e_n  : in  std_logic;
      in_0 : in  std_logic_vector(3 downto 0);
      in_1 : in  std_logic_vector(3 downto 0);
      y    : out std_logic_vector(3 downto 0)
    );
  end component;

  -- 8-bit Shift Register
  component sr_74xx595 is
    port(
      rclk     : in  std_logic; -- register latch clock
      srclk    : in  std_logic; -- serial clock
      srclkr_n : in  std_logic; -- register clear
      oe_n     : in  std_logic; 
      ser      : in  std_logic;
      qa       : out std_logic;
      qb       : out std_logic;
      qc       : out std_logic;
      qd       : out std_logic;
      qe       : out std_logic;
      qf       : out std_logic;
      qg       : out std_logic;
      qh       : out std_logic;
      qh_s     : out std_logic
    );
  end component;

  -- XOR (quad) dual-input
  component xor_74xx86 is
    port(
      a : in  std_logic_vector(3 downto 0);
      b : in  std_logic_vector(3 downto 0);  
      y : out std_logic_vector(3 downto 0)
    );
  end component;

  signal reg_clk     : std_logic;  -- register clock for D-flip flop stage

  -- LUT input signals
  signal A0,A1,A2,A3 : std_logic;
  signal B0,B1,B2,B3 : std_logic;
  signal C0,C1,C2,C3 : std_logic;
  signal D0,D1,D2,D3 : std_logic;
  signal insel_a0_in : std_logic_vector(3 downto 0);
  signal insel_a1_in : std_logic_vector(3 downto 0);
  signal insel_b0_in : std_logic_vector(3 downto 0);
  signal insel_b1_in : std_logic_vector(3 downto 0);
  signal insel_c0_in : std_logic_vector(3 downto 0);
  signal insel_c1_in : std_logic_vector(3 downto 0);
  signal insel_d0_in : std_logic_vector(3 downto 0);
  signal insel_d1_in : std_logic_vector(3 downto 0);

  -- LUT3 contents
  signal LUT3a0      : std_logic_vector(7 downto 0);
  signal LUT3a1      : std_logic_vector(7 downto 0);
  signal LUT3b0      : std_logic_vector(7 downto 0);
  signal LUT3b1      : std_logic_vector(7 downto 0);
  signal LUT3c0      : std_logic_vector(7 downto 0);
  signal LUT3c1      : std_logic_vector(7 downto 0);
  signal LUT3d0      : std_logic_vector(7 downto 0);
  signal LUT3d1      : std_logic_vector(7 downto 0);

  -- LUT3 selectors
  signal LUT3_sel_a  : std_logic_vector(2 downto 0);
  signal LUT3_sel_b  : std_logic_vector(2 downto 0);
  signal LUT3_sel_c  : std_logic_vector(2 downto 0);
  signal LUT3_sel_d  : std_logic_vector(2 downto 0);

  -- LUT3 outputs
  signal La0, La1    : std_logic;
  signal Lb0, Lb1    : std_logic;
  signal Lc0, Lc1    : std_logic;
  signal Ld0, Ld1    : std_logic;

  -- LUT4 outputs
  signal La,Lb,Lc,Ld : std_logic;

  -- carry chain
  signal cca,ccb,ccc,ccd : std_logic;
  signal i_xor_lx        : std_logic_vector(3 downto 0);
  signal i_xor_cc        : std_logic_vector(3 downto 0);
  signal xor_S           : std_logic_vector(3 downto 0);
  signal sum_O           : std_logic_vector(3 downto 0);
  signal Sa,Sb,Sc,Sd     : std_logic;
  signal Oa,Ob,Oc,Od     : std_logic;

  -- flip flop
  signal ff_vect_in      : std_logic_vector(7 downto 0);
  signal ff_vect_out     : std_logic_vector(7 downto 0);
  signal sum_O_reg       : std_logic_vector(3 downto 0);

  -- bitstream configuration SPI
  signal ser_in_to_insel      : std_logic;
  signal insel_to_lut_d0      : std_logic;
  signal lut_d0_to_lut_d1     : std_logic;
  signal lut_d1_to_lut_c0     : std_logic;
  signal lut_c0_to_lut_c1     : std_logic;
  signal lut_c1_to_lut_b0     : std_logic;
  signal lut_b0_to_lut_b1     : std_logic;
  signal lut_b1_to_lut_a0     : std_logic;
  signal lut_a0_to_lut_a1     : std_logic;
  signal lut_a1_to_config     : std_logic;
  signal config_to_serout     : std_logic;

  -- config signals 
  signal set_reg_a   : std_logic;
  signal set_reg_b   : std_logic;
  signal set_reg_c   : std_logic;
  signal set_reg_d   : std_logic;
  signal set_sum     : std_logic;
  signal set_clk_sel : std_logic;
  signal insel_a     : std_logic_vector(1 downto 0);
  signal insel_b     : std_logic_vector(1 downto 0);
  signal insel_c     : std_logic_vector(1 downto 0);
  signal insel_d     : std_logic_vector(1 downto 0);

  -- testbench signals
  signal test_sum_0_in : std_logic_vector(5 downto 0);
  signal test_sum_1_in : std_logic_vector(5 downto 0);
  signal test_sum_2_in : std_logic_vector(5 downto 0);
  signal test_sum_ref  : std_logic_vector(5 downto 0);
  signal test_sum_out  : std_logic_vector(5 downto 0);


begin

  test_sum_0_in(0) <= A0;
  test_sum_0_in(1) <= B0;
  test_sum_0_in(2) <= C0;
  test_sum_0_in(3) <= D0;
  test_sum_0_in(4) <= '0';
  test_sum_0_in(5) <= '0';

  test_sum_1_in(0) <= A1;
  test_sum_1_in(1) <= B1;
  test_sum_1_in(2) <= C1;
  test_sum_1_in(3) <= D1;
  test_sum_1_in(4) <= '0';
  test_sum_1_in(5) <= '0';

  test_sum_2_in <= "00000" & cin;

  test_sum_out(5) <= '0';
  test_sum_out(4) <= ccd;
  test_sum_out(3 downto 0) <= ff_vect_in(3 downto 0);
  test_sum_ref <= std_logic_vector(unsigned(test_sum_0_in) + unsigned(test_sum_1_in) + unsigned(test_sum_2_in));

  p_sum_check : process(reg_clk)
  begin 
    if falling_edge(reg_clk) then
      if set_sum = '1' then
        assert La = (A0 xor A1) report "La = A0 xor A1 error! (" & std_logic'image(A0) & " xor " & std_logic'image(A1) & " = " & std_logic'image(La) & ")";
        assert Lb = (B0 xor B1) report "Lb = B0 xor B1 error! (" & std_logic'image(B0) & " xor " & std_logic'image(B1) & " = " & std_logic'image(Lb) & ")";
        assert Lc = (C0 xor C1) report "Lc = C0 xor C1 error! (" & std_logic'image(C0) & " xor " & std_logic'image(C1) & " = " & std_logic'image(Lc) & ")";
        assert Ld = (D0 xor D1) report "Ld = D0 xor D1 error! (" & std_logic'image(D0) & " xor " & std_logic'image(D1) & " = " & std_logic'image(Ld) & ")";
        if (cin and La) = '1' then
          assert cca = '1' report "Carry chain error for cca!";
        end if;
        if (cca and Lb) = '1' then
          assert ccb = '1' report "Carry chain error for ccb!";
        end if;
        if (ccb and Lc) = '1' then
          assert ccc = '1' report "Carry chain error for ccc!";
        end if;
        assert Oa = (A0 xor A1 xor cin) report "Oa = A0 + A1 + c sum with carry error (" & std_logic'image(A0) & " xor " & std_logic'image(A1) & " xor " & std_logic'image(cin) & " = " & std_logic'image(Oa) & ")";
        assert Ob = (B0 xor B1 xor cca) report "Ob = B0 + B1 + c sum with carry error (" & std_logic'image(B0) & " xor " & std_logic'image(B1) & " xor " & std_logic'image(cca) & " = " & std_logic'image(Ob) & ")";
        assert Oc = (C0 xor C1 xor ccb) report "Oc = C0 + C1 + c sum with carry error (" & std_logic'image(C0) & " xor " & std_logic'image(C1) & " xor " & std_logic'image(ccb) & " = " & std_logic'image(Oc) & ")";
        assert Od = (D0 xor D1 xor ccc) report "Od = D0 + D1 + c sum with carry error (" & std_logic'image(D0) & " xor " & std_logic'image(D1) & " xor " & std_logic'image(ccc) & " = " & std_logic'image(Od) & ")";

        assert (unsigned(test_sum_ref) = unsigned(test_sum_out)) report "failed sum calculation!";
      end if;
    end if;
  end process;
  ser_in_to_insel <= mosi;

  -- input selection
  A2 <= cb_pre(2);
  A3 <= cb_pre(3);
  B2 <= cb_pre(2);
  B3 <= cb_pre(3);
  C2 <= cb_pre(2);
  C3 <= cb_pre(3);
  D2 <= cb_pre(2);
  D3 <= cb_pre(3);

  insel_a0_in(0) <= cb_pre(0);
  insel_a1_in(0) <= cb_pre(1);
  insel_b0_in(0) <= cb_pre(0);
  insel_b1_in(0) <= cb_pre(1);
  insel_c0_in(0) <= cb_pre(0);
  insel_c1_in(0) <= cb_pre(1);
  insel_d0_in(0) <= cb_pre(0);
  insel_d1_in(0) <= cb_pre(1);

  insel_a0_in(1) <= cb_w(0); -- cb_w(1);
  insel_a1_in(1) <= cb_pre(1); -- cb_w(0);
  insel_b0_in(1) <= cb_w(1); -- cb_w(1);
  insel_b1_in(1) <= cb_pre(1); -- cb_w(0);
  insel_c0_in(1) <= cb_w(2); -- cb_w(1);
  insel_c1_in(1) <= cb_pre(1); -- cb_w(0);
  insel_d0_in(1) <= cb_w(3); -- cb_w(1);
  insel_d1_in(1) <= cb_pre(1); -- cb_w(0);

  insel_a0_in(2) <= cb_n(0);
  insel_a1_in(2) <= cb_s(0);
  insel_b0_in(2) <= cb_n(1);
  insel_b1_in(2) <= cb_s(1);
  insel_c0_in(2) <= cb_n(2);
  insel_c1_in(2) <= cb_s(2);
  insel_d0_in(2) <= cb_n(3);
  insel_d1_in(2) <= cb_s(3);

  insel_a0_in(3) <= cb_n(3);
  insel_a1_in(3) <= cb_s(3);
  insel_b0_in(3) <= cb_n(2);
  insel_b1_in(3) <= cb_s(2);
  insel_c0_in(3) <= cb_n(1);
  insel_c1_in(3) <= cb_s(1);
  insel_d0_in(3) <= cb_n(0);
  insel_d1_in(3) <= cb_s(0);

  LUT3_sel_a(0) <= A0;
  LUT3_sel_a(1) <= A1;
  LUT3_sel_a(2) <= A2;

  LUT3_sel_b(0) <= B0;
  LUT3_sel_b(1) <= B1;
  LUT3_sel_b(2) <= B2;

  LUT3_sel_c(0) <= C0;
  LUT3_sel_c(1) <= C1;
  LUT3_sel_c(2) <= C2;

  LUT3_sel_d(0) <= D0;
  LUT3_sel_d(1) <= D1;
  LUT3_sel_d(2) <= D2;

  inMUXa_inst : mux_74xx153
    port map (
      s    => insel_a,
      e1_n => '0', 
      e2_n => '0', 
      i1   => insel_a0_in, 
      i2   => insel_a1_in, 
      y1   => A0, 
      y2   => A1
    );

  inMUXb_inst : mux_74xx153
    port map (
      s    => insel_b,
      e1_n => '0', 
      e2_n => '0', 
      i1   => insel_b0_in, 
      i2   => insel_b1_in, 
      y1   => B0, 
      y2   => B1
    );

  inMUXc_inst : mux_74xx153
    port map (
      s    => insel_c,
      e1_n => '0', 
      e2_n => '0', 
      i1   => insel_c0_in, 
      i2   => insel_c1_in, 
      y1   => C0, 
      y2   => C1
    );

  inMUXd_inst : mux_74xx153
    port map (
      s    => insel_d,
      e1_n => '0', 
      e2_n => '0', 
      i1   => insel_d0_in, 
      i2   => insel_d1_in, 
      y1   => D0, 
      y2   => D1
    );

  -- LUT A ---------------------------------------------------------------------
  LUT3a0_inst : sr_74xx595
    port map (
      rclk     => latch, 
      srclk    => sclk, 
      srclkr_n => clr_n, 
      oe_n     => '0', 
      ser      => lut_b1_to_lut_a0, 
      qa       => LUT3a0(0),
      qb       => LUT3a0(1),
      qc       => LUT3a0(2),
      qd       => LUT3a0(3),
      qe       => LUT3a0(4),
      qf       => LUT3a0(5),
      qg       => LUT3a0(6),
      qh       => LUT3a0(7),
      qh_s     => lut_a0_to_lut_a1
    );

  LUT3a1_inst : sr_74xx595
    port map (
      rclk     => latch, 
      srclk    => sclk, 
      srclkr_n => clr_n, 
      oe_n     => '0', 
      ser      => lut_a0_to_lut_a1,
      qa       => LUT3a1(0),
      qb       => LUT3a1(1),
      qc       => LUT3a1(2),
      qd       => LUT3a1(3),
      qe       => LUT3a1(4),
      qf       => LUT3a1(5),
      qg       => LUT3a1(6),
      qh       => LUT3a1(7),
      qh_s     => lut_a1_to_config
    );

  LUT3MUXa0_inst : mux_74xx151 
    port map (
      s   => LUT3_sel_a, 
      e_n => '0', 
      i   => LUT3a0, 
      y   => La0
    );

  LUT3MUXa1_inst : mux_74xx151 
    port map (
      s   => LUT3_sel_a, 
      e_n => '0', 
      i   => LUT3a1, 
      y   => La1
    );

  LUT4MUXa_inst : mux_74LVC1G157
    port map (
      s   => A3,
      e_n => '0',
      i0  => La0,
      i1  => La1,
      y   => La
    );

  carry_mux_a : mux_74LVC1G157
    port map (
      s   => La,
      e_n => '0',
      i0  => A1,
      i1  => cin,
      y   => cca
    );

  -- LUT B ---------------------------------------------------------------------
  LUT3b0_inst : sr_74xx595
    port map (
      rclk     => latch, 
      srclk    => sclk, 
      srclkr_n => clr_n, 
      oe_n     => '0', 
      ser      => lut_c1_to_lut_b0, 
      qa       => LUT3b0(0),
      qb       => LUT3b0(1),
      qc       => LUT3b0(2),
      qd       => LUT3b0(3),
      qe       => LUT3b0(4),
      qf       => LUT3b0(5),
      qg       => LUT3b0(6),
      qh       => LUT3b0(7),
      qh_s     => lut_b0_to_lut_b1
    );

  LUT3b1_inst : sr_74xx595
    port map (
      rclk     => latch, 
      srclk    => sclk, 
      srclkr_n => clr_n, 
      oe_n     => '0', 
      ser      => lut_b0_to_lut_b1,
      qa       => LUT3b1(0),
      qb       => LUT3b1(1),
      qc       => LUT3b1(2),
      qd       => LUT3b1(3),
      qe       => LUT3b1(4),
      qf       => LUT3b1(5),
      qg       => LUT3b1(6),
      qh       => LUT3b1(7),
      qh_s     => lut_b1_to_lut_a0
    );

  LUT3MUXb0_inst : mux_74xx151 
    port map (
      s   => LUT3_sel_b, 
      e_n => '0', 
      i   => LUT3b0, 
      y   => Lb0
    );

  LUT3MUXb1_inst : mux_74xx151 
    port map (
      s   => LUT3_sel_b, 
      e_n => '0', 
      i   => LUT3b1, 
      y   => Lb1
    );

  LUT4MUXb_inst : mux_74LVC1G157
    port map (
      s   => B3,
      e_n => '0',
      i0  => Lb0,
      i1  => Lb1,
      y   => Lb
    );

  carry_mux_b : mux_74LVC1G157
    port map (
      s   => Lb,
      e_n => '0',
      i0  => B1,
      i1  => cca,
      y   => ccb
    );

  -- LUT C ---------------------------------------------------------------------
  LUT3c0_inst : sr_74xx595
    port map (
      rclk     => latch, 
      srclk    => sclk, 
      srclkr_n => clr_n, 
      oe_n     => '0', 
      ser      => lut_d1_to_lut_c0, 
      qa       => LUT3c0(0),
      qb       => LUT3c0(1),
      qc       => LUT3c0(2),
      qd       => LUT3c0(3),
      qe       => LUT3c0(4),
      qf       => LUT3c0(5),
      qg       => LUT3c0(6),
      qh       => LUT3c0(7),
      qh_s     => lut_c0_to_lut_c1
    );

  LUT3c1_inst : sr_74xx595
    port map (
      rclk     => latch, 
      srclk    => sclk, 
      srclkr_n => clr_n, 
      oe_n     => '0', 
      ser      => lut_c0_to_lut_c1,
      qa       => LUT3c1(0),
      qb       => LUT3c1(1),
      qc       => LUT3c1(2),
      qd       => LUT3c1(3),
      qe       => LUT3c1(4),
      qf       => LUT3c1(5),
      qg       => LUT3c1(6),
      qh       => LUT3c1(7),
      qh_s     => lut_c1_to_lut_b0
    );

  LUT3MUXc0_inst : mux_74xx151 
    port map (
      s   => LUT3_sel_c, 
      e_n => '0', 
      i   => LUT3c0, 
      y   => Lc0
    );

  LUT3MUXc1_inst : mux_74xx151 
    port map (
      s   => LUT3_sel_c, 
      e_n => '0', 
      i   => LUT3c1, 
      y   => Lc1
    );

  LUT4MUXc_inst : mux_74LVC1G157
    port map (
      s   => C3,
      e_n => '0',
      i0  => Lc0,
      i1  => Lc1,
      y   => Lc
    );

  carry_mux_c : mux_74LVC1G157
    port map (
      s   => Lc,
      e_n => '0',
      i0  => C1,
      i1  => ccb,
      y   => ccc
    );

  -- LUT D ---------------------------------------------------------------------
  LUT3d0_inst : sr_74xx595
    port map (
      rclk     => latch, 
      srclk    => sclk, 
      srclkr_n => clr_n, 
      oe_n     => '0', 
      ser      => insel_to_lut_d0, 
      qa       => LUT3d0(0),
      qb       => LUT3d0(1),
      qc       => LUT3d0(2),
      qd       => LUT3d0(3),
      qe       => LUT3d0(4),
      qf       => LUT3d0(5),
      qg       => LUT3d0(6),
      qh       => LUT3d0(7),
      qh_s     => lut_d0_to_lut_d1
    );

  LUT3d1_inst : sr_74xx595
    port map (
      rclk     => latch, 
      srclk    => sclk, 
      srclkr_n => clr_n, 
      oe_n     => '0', 
      ser      => lut_d0_to_lut_d1,
      qa       => LUT3d1(0),
      qb       => LUT3d1(1),
      qc       => LUT3d1(2),
      qd       => LUT3d1(3),
      qe       => LUT3d1(4),
      qf       => LUT3d1(5),
      qg       => LUT3d1(6),
      qh       => LUT3d1(7),
      qh_s     => lut_d1_to_lut_c0
    );

  LUT3MUXd0_inst : mux_74xx151 
    port map (
      s   => LUT3_sel_d, 
      e_n => '0', 
      i   => LUT3d0, 
      y   => Ld0
    );

  LUT3MUXd1_inst : mux_74xx151 
    port map (
      s   => LUT3_sel_d, 
      e_n => '0', 
      i   => LUT3d1, 
      y   => Ld1
    );

  LUT4MUXd_inst : mux_74LVC1G157
    port map (
      s   => D3,
      e_n => '0',
      i0  => Ld0,
      i1  => Ld1,
      y   => Ld
    );

  carry_mux_d : mux_74LVC1G157
    port map (
      s   => Ld,
      e_n => '0',
      i0  => D1,
      i1  => ccc,
      y   => ccd
    );

  cout <= ccd;

  -- carry chain XOR
  i_xor_lx(0) <= La;
  i_xor_lx(1) <= Lb;
  i_xor_lx(2) <= Lc;
  i_xor_lx(3) <= Ld;
  i_xor_cc(0) <= cin;
  i_xor_cc(1) <= cca;
  i_xor_cc(2) <= ccb;
  i_xor_cc(3) <= ccc;
  Sa <= xor_S(0);
  Sb <= xor_S(1);
  Sc <= xor_S(2);
  Sd <= xor_S(3);
  Oa <= sum_O(0);
  Ob <= sum_O(1);
  Oc <= sum_O(2);
  Od <= sum_O(3);

  -- XOR (quad) to calculate sum
  xor_inst : xor_74xx86 
    port map (
      a => i_xor_lx,
      b => i_xor_cc,  
      y => xor_S
    );

  -- quad 2:1 mux to switch between carry chain and LUT operation
  sum_out_mux : mux_74xx157 
    port map (
      s    => set_sum, 
      e_n  => '0', 
      in_0 => i_xor_lx, 
      in_1 => xor_S, 
      y    => sum_O
    );

  -- register stage ------------------------------------------------------------ 
  -- taking carry output as input
  ff_stage_inst : ff_74xx175
    port map (
      clk    => reg_clk, 
      arst_n => rst_n, 
      din    => ff_vect_in, 
      qout   => ff_vect_out, 
      qout_n => open
    );

  ff_vect_in(3 downto 0) <= sum_O;
  sum_O_reg <= ff_vect_out(3 downto 0);

  -- output selection ----------------------------------------------------------
  out_select_a : mux_74LVC1G157
    port map (
      s   => set_reg_a,
      e_n => '0',
      i0  => Oa,
      i1  => sum_O_reg(0),
      y   => Qa
    );
  out_select_b : mux_74LVC1G157
    port map (
      s   => set_reg_b,
      e_n => '0',
      i0  => Ob,
      i1  => sum_O_reg(1),
      y   => Qb
    );
  out_select_c : mux_74LVC1G157
    port map (
      s   => set_reg_c,
      e_n => '0',
      i0  => Oc,
      i1  => sum_O_reg(2),
      y   => Qc
    );
  out_select_d : mux_74LVC1G157
    port map (
      s   => set_reg_d,
      e_n => '0',
      i0  => Od,
      i1  => sum_O_reg(3),
      y   => Qd
    );

  -- clock input selector ------------------------------------------------------
  clk_mux_inst : mux_74LVC1G157
    port map (
      s   => set_clk_sel, 
      e_n => '0', 
      i0  => clk_0, 
      i1  => clk_1, 
      y   => reg_clk
    );


  insel_reg_inst : sr_74xx595
    port map (
      rclk     => latch, 
      srclk    => sclk, 
      srclkr_n => clr_n, 
      oe_n     => '0', 
      ser      => ser_in_to_insel,
      qa       => insel_a(0),
      qb       => insel_a(1),
      qc       => insel_b(0),
      qd       => insel_b(1),
      qe       => insel_c(0),
      qf       => insel_c(1),
      qg       => insel_d(0),
      qh       => insel_d(1),
      qh_s     => insel_to_lut_d0 
    );

  config_reg_inst : sr_74xx595
    port map (
      rclk     => latch, 
      srclk    => sclk, 
      srclkr_n => clr_n, 
      oe_n     => '0', 
      ser      => lut_a1_to_config,
      qa       => set_reg_a,
      qb       => set_reg_b,
      qc       => set_reg_c,
      qd       => set_reg_d,
      qe       => set_sum,
      qf       => set_clk_sel,
      qg       => open,
      qh       => open,
      qh_s     => config_to_serout 
    );


  miso <= config_to_serout;

end architecture;
