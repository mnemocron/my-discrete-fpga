# Architecture

---

## Configurable Logic Block (CLB) Slice

One CLB consists of 4 individual LUT4 entities connected to a carry-chain.
Letters from `A` to `D` are used to identify the 4 LUT instances.
The bottom-most LUT4 is identified as `A`.

The following documentation uses letter index `A` for all signals and primitives.

### CLB configuration

There are 2 bytes of configuration per CLB.

| field | function | description |
|:--|:--|:--|
| `Xa` | `set_reg_a` | register enable for slice `A` |
| `Xb` | `set_reg_b` | register enable for slice `B` |
| `Xc` | `set_reg_c` | register enable for slice `C` |
| `Xd` | `set_reg_d` | register enable for slice `D` |
| `Xe` | `set_sum` | sum mode enable for entire CLB |
| `Xf` | `set_clk_sel` | clock select `0` for `clk_0` |
| `Xg` | `set_` | <unused> |
| `Xh` | `set_` | <unused> |
| `Ya` | `insel_a0` | LUT3a input select 0 |
| `Yb` | `insel_a1` | LUT3a input select 1 |
| `Yc` | `insel_b0` | LUT3b input select 0 |
| `Yd` | `insel_b1` | LUT3b input select 1 |
| `Ye` | `insel_c0` | LUT3c input select 0 |
| `Yf` | `insel_c1` | LUT3c input select 1 |
| `Yg` | `insel_d0` | LUT3d input select 0 |
| `Yh` | `insel_d1` | LUT3d input select 1 |

```
[ MSB           ...          LSB ]
[ Yh, Yg, Yf, Ye, Yd, Yc, Yb, Ya ]
[ Xh, Xg, Xf, Xe, Xd, Xc, Xb, Xa ]
```

| `insel_*[1:0]` | selected input |
|:--|:--|
| `00` | `preselect[1:0]` |
| `01` | `cb_west[1:0]` |
| `10` | sum input `north[3:0]` + `south[3:0]` |
| `11` | sum input `north[0:3]` + `south[0:3]` (reversed) |

**example bitstream** with register enabled, clk_0, regular mode, preselected input

```
00000000
00001111
```

### LUT3 / LUT4 Primitive

The LUT4 is composed of 2 separate LUT3 entities. Each `LUT3*[1:0]` entity has one byte of LUT memory that is presented at the output.
The outputs are indexed `Qa` to `Qh` for `A3=0` and `Pa` to `Ph` for `A3=1`.

LUT4 memory truth table with inputs `A(3 downto 0)`

| `[A3,A2,A1,A0]` | field |
|:--|:--|
| `0000` | `Qa` |
| `0001` | `Qb` |
| `0010` | `Qc` |
| `0011` | `Qd` |
| `0100` | `Qe` |
| `0101` | `Qf` |
| `0110` | `Qg` |
| `0111` | `Qh` |
| `1000` | `Pa` |
| `1001` | `Pb` |
| `1010` | `Pc` |
| `1011` | `Pd` |
| `1100` | `Pe` |
| `1101` | `Pf` |
| `1110` | `Pg` |
| `1111` | `Ph` |

This is represented as 2 bytes in the bitstream in MSB-first notation

```
[ MSB           ...          LSB ]
[ Ph, Pg, Pf, Pe, Pd, Pc, Pb, Pa ]
[ Qh, Qg, Qf, Qe, Qd, Qc, Qb, Qa ]
```
#### LUT4 example bitstreams:

**Quad-Input XOR**

| `[A3,A2,A1,A0]` | field | value |
|:--|:--|:--|
| `0000` | `Qa` | `0` |
| `0001` | `Qb` | `1` |
| `0010` | `Qc` | `1` |
| `0011` | `Qd` | `0` |
| `0100` | `Qe` | `1` |
| `0101` | `Qf` | `0` |
| `0110` | `Qg` | `0` |
| `0111` | `Qh` | `0` |
| `1000` | `Pa` | `1` |
| `1001` | `Pb` | `0` |
| `1010` | `Pc` | `0` |
| `1011` | `Pd` | `0` |
| `1100` | `Pe` | `0` |
| `1101` | `Pf` | `0` |
| `1110` | `Pg` | `0` |
| `1111` | `Ph` | `0` |

```
00000001
00010110
```

**Quad-Input AND**

| `[A3,A2,A1,A0]` | field | value |
|:--|:--|:--|
| `0000` | `Qa` | `0` |
| `0001` | `Qb` | `0` |
| `0010` | `Qc` | `0` |
| `0011` | `Qd` | `0` |
| `0100` | `Qe` | `0` |
| `0101` | `Qf` | `0` |
| `0110` | `Qg` | `0` |
| `0111` | `Qh` | `0` |
| `1000` | `Pa` | `0` |
| `1001` | `Pb` | `0` |
| `1010` | `Pc` | `0` |
| `1011` | `Pd` | `0` |
| `1100` | `Pe` | `0` |
| `1101` | `Pf` | `0` |
| `1110` | `Pg` | `0` |
| `1111` | `Ph` | `1` |

```
10000000
00000000
```

**4-bit Even Parity**

| `[A3,A2,A1,A0]` | field | value |
|:--|:--|:--|
| `0000` | `Qa` | `0` |
| `0001` | `Qb` | `1` |
| `0010` | `Qc` | `1` |
| `0011` | `Qd` | `0` |
| `0100` | `Qe` | `1` |
| `0101` | `Qf` | `0` |
| `0110` | `Qg` | `0` |
| `0111` | `Qh` | `1` |
| `1000` | `Pa` | `1` |
| `1001` | `Pb` | `0` |
| `1010` | `Pc` | `0` |
| `1011` | `Pd` | `1` |
| `1100` | `Pe` | `0` |
| `1101` | `Pf` | `1` |
| `1110` | `Pg` | `1` |
| `1111` | `Ph` | `0` |

```
01101001
10010110
```

**2-Input NAND** (on LSB `A1`,`A0`)

| `[A3,A2,A1,A0]` | field | value |
|:--|:--|:--|
| `0000` | `Qa` | `1` |
| `0001` | `Qb` | `1` |
| `0010` | `Qc` | `1` |
| `0011` | `Qd` | `0` |
| `0100` | `Qe` | `1` |
| `0101` | `Qf` | `1` |
| `0110` | `Qg` | `1` |
| `0111` | `Qh` | `0` |
| `1000` | `Pa` | `x` |
| `1001` | `Pb` | `x` |
| `1010` | `Pc` | `x` |
| `1011` | `Pd` | `x` |
| `1100` | `Pe` | `x` |
| `1101` | `Pf` | `x` |
| `1110` | `Pg` | `x` |
| `1111` | `Ph` | `x` |

```
00000000
01110111
```
