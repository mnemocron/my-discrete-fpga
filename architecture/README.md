# Architecture

---


Bitstream is **MSB first**


## Switch Box

### SW configuration

**connect south to west**

``` 
00000000
00001111
00001111
00001111
```

**connect south to west + prio(0) to prio(0)**

```
00010001
00001111
00001111
00011111
```

## Connection Box (horizontal)

### CBh configuration

There are 2 bytes of configuration.

| pos | function | description |
|--:|:--|:--|
|  0 | `sel_0[0]`      | Input selection for LUT input 0 |
|  1 | `sel_0[1]`      | Input selection for LUT input 0 |
|  2 | `sel_0[2]`      | Input selection for LUT input 0 |
|  3 | `xpoint_cin`    | Connect the LUT `cout` to the priority line for `cin` |
|  4 | `sel_1[0]`      | Input selection for LUT input 1 |
|  5 | `sel_1[1]`      | Input selection for LUT input 1 |
|  6 | `sel_1[2]`      | Input selection for LUT input 1 |
|  7 | `xpoint_cout_n` | Connect the `cout` from south LUT on the priority line to the `cin` of the north LUT |
|  8 | `sel_2[0]`      | Input selection for LUT input 2 |
|  9 | `sel_2[1]`      | Input selection for LUT input 2 |
| 10 | `sel_2[2]`      | Input selection for LUT input 2 |
| 11 | `xpoint_cout_s` | Connect the `cout` from the priority line to the `cin` of the south LUT |
| 12 | `sel_3[0]`      | Input selection for LUT input 3 |
| 13 | `sel_3[1]`      | Input selection for LUT input 3 |
| 14 | `sel_3[2]`      | Input selection for LUT input 3 |
| 15 | `-`             | <unused> |


### Input Selection Table

| `sel_*[2:0]` | selected input |
|------:|:---|
| `000` | `0` / `GND` |
| `001` | `1` / `Vcc` |
| `010` | Priority Line 1 |
| `011` | Priority Line 0 |
| `100` | Bus 3 |
| `101` | Bus 2 |
| `110` | Bus 1 |
| `111` | Bus 0 |

**regular input connection (no cin/cout)**

```
01000101
01100111
```

**sum mode (all to GND) + cout forwarding to priority bus**

```
00000000
00001000
```


## Connection Box (vertical)

### CBv configuration

There is 1 byte of configuration.

| pos | field | function | description |
|--:|:--|:--|:--|
|  0 | `W0` | `xpoint_0` | Connects LUT output 0 to main north/south bus 0 |
|  1 | `W1` | `xpoint_1` | Connects LUT output 1 to main north/south bus 1 |
|  2 | `W2` | `xpoint_2` | Connects LUT output 2 to main north/south bus 2 |
|  3 | `W3` | `xpoint_3` | Connects LUT output 3 to main north/south bus 3 |
|  4 | `P0` | `xpoint_4` | Connects LUT output 0 to priority bus 1 |
|  5 | `P1` | `xpoint_5` | Connects LUT output 1 to priority bus 0 |
|  6 | `P2` | `xpoint_6` | Connects LUT output 2 to priority bus 1 |
|  7 | `P3` | `xpoint_7` | Connects LUT output 3 to priority bus 0 |

```
[ MSB           ...          LSB ]
[ P3, P2, P1, P0, W3, W2, W1, W0 ]
```

## Configurable Logic Block (CLB) Slice

One CLB consists of 4 individual LUT4 entities connected to a carry-chain.
Letters from `A` to `D` are used to identify the 4 LUT instances.
The bottom-most LUT4 is identified as `A`.

The following documentation uses letter index `A` for all signals and primitives.

### CLB configuration

There are 2 bytes of configuration per CLB.

| pos | field | function | description |
|--:|:--|:--|:--|
|  0 | `Xa` | `set_reg_a` | register enable for slice `A` |
|  1 | `Xb` | `set_reg_b` | register enable for slice `B` |
|  2 | `Xc` | `set_reg_c` | register enable for slice `C` |
|  3 | `Xd` | `set_reg_d` | register enable for slice `D` |
|  4 | `Xe` | `set_sum` | sum mode enable for entire CLB |
|  5 | `Xf` | `set_clk_sel` | clock select `0` for `clk_0` |
|  6 | `Xg` | `set_` | <unused> |
|  7 | `Xh` | `set_` | <unused> |
|  8 | `Ya` | `insel_a0` | LUT3a input select 0 |
|  9 | `Yb` | `insel_a1` | LUT3a input select 1 |
| 10 | `Yc` | `insel_b0` | LUT3b input select 0 |
| 11 | `Yd` | `insel_b1` | LUT3b input select 1 |
| 12 | `Ye` | `insel_c0` | LUT3c input select 0 |
| 13 | `Yf` | `insel_c1` | LUT3c input select 1 |
| 14 | `Yg` | `insel_d0` | LUT3d input select 0 |
| 15 | `Yh` | `insel_d1` | LUT3d input select 1 |

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
| `1000` | `Pa` | `1` |
| `1001` | `Pb` | `1` |
| `1010` | `Pc` | `1` |
| `1011` | `Pd` | `0` |
| `1100` | `Pe` | `1` |
| `1101` | `Pf` | `1` |
| `1110` | `Pg` | `1` |
| `1111` | `Ph` | `0` |

```
01110111
01110111
```

**sum mode / 2-Input XOR** (on LSB `A1`,`A0`)

| `[A3,A2,A1,A0]` | field | value |
|:--|:--|:--|
| `0000` | `Qa` | `0` |
| `0001` | `Qb` | `1` |
| `0010` | `Qc` | `1` |
| `0011` | `Qd` | `0` |
| `0100` | `Qe` | `0` |
| `0101` | `Qf` | `1` |
| `0110` | `Qg` | `1` |
| `0111` | `Qh` | `0` |
| `1000` | `Pa` | `0` |
| `1001` | `Pb` | `1` |
| `1010` | `Pc` | `1` |
| `1011` | `Pd` | `0` |
| `1100` | `Pe` | `0` |
| `1101` | `Pf` | `1` |
| `1110` | `Pg` | `1` |
| `1111` | `Ph` | `0` |

```
01100110
01100110
```
