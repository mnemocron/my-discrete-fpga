# VHDL Simulation
---


### MUX 8:1 74xx151 / 74xx251
- Single 8-Input Multiplexer
- for LUT3 elements

### MUX 4:1 74xx153 / 74xx253
- Dual 4-Input Multiplexer
- CLB tile input 2/3 select

### MUX 2:1 74xx157 / 74xx257
- Quad 2-Input Multiplexer
- sum output selector (`set_sum`)

### MUX 2:1 74-1G157
- Single 2-Input Multiplexer
- LUT4 element, set_reg, carry_mux

### D-type Register 74xx175
- Quad D-type Flip Flop

### XOR 74xx86
- Quad 2-Input XOR
- sum

### Shift Register 74xx595
- 8-bit shift register with latch
- LUT3 memory, configuration registers

### MAX5102 DAC

- 8-bit DAC
- parallel input
- asymmetrical supply voltage

---

| IC | simulation |
|:---|:-----------|
| 74xx157 | ✅ |
| 74xx153 | ✅ |
| 74xx151 | ✅ |
| 74xx175 | ✅ |
| 74xx595 | ✅ |
| 74xx86  | ✅ |
| 74_1G157 | ✅ |

---

## Interconnect Simulation

- use `std_logic` not `std_ulogic` because of "multiple drivers"
- 

