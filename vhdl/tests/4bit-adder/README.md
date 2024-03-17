# Simple Bit Inverter

---

using LUT B

will output `clb_slice.Qb` --> `connection_box_vertical.bus_west[1]`

- `connection_box_vertical.xpoint_1_en = 1` (6)

will output `connection_box_vertical.bus_north[1]` --> `sw_box.bus_south[1]`

- `sw_box.sw_9 = 1` (126)
- `sw_box.sw_17 = 1` (118)
- `sw_box.xpoint_1 = 1` (134)

will output `sw_box.bus_west[1]` --> `connection_box_horizontal.bus_east[1]`

let's just pick preselect 2 and leave all other preselect to 0 (GND).

- `connection_box_horizontal.presel_2[0] = 0` 
- `connection_box_horizontal.presel_2[1] = 1` (93)
- `connection_box_horizontal.presel_2[2] = 1` (94)

will output `sw_box.preselect[2]` --> `clb_slice.cb_pre[2]`

`presel[2]` affects the LUT3 stage. implement an inverter where all other inputs are `X` (don't care)

- `insel`

- `LUT3b1[0] = 1` (52)
- `LUT3b1[1] = 1` (53)
- `LUT3b1[2] = 1` (54)
- `LUT3b1[3] = 1` (55)

- `LUT3b0[0] = 1` (44)
- `LUT3b0[1] = 1` (45)
- `LUT3b0[2] = 1` (46)
- `LUT3b0[3] = 1` (47)

- `set_reg_b = 1` (76)
