# 4Bit-FPGA

---

## Application Use Cases

- 4-bit counter
- 4-bit counter with GPIO output
- 4-bit counter with 7-segment converter
- 4-bit counter with 7-segment hard-IP
- 4 + 4 bit adder from external GPIO input
- "roll a dice" with 2-clock domains, double flop synchronization, button press, and edge detection

something with RAM
- timer which stores counter value in BRAM, readout by cycle-clicking again
- toggle on RAM full/empty bits

CPU
- 

hard-IP
- BCD to 7-segment

cpu = custom instruction

### 4:1 CLB/LUT

4 bits is the ideal compromise for the planned application use cases.
4 bits are used in BCD numbering and is a reasonable amount for a counter application.

- clk_in[1:0]
- clb_in[3:0]
- clb_out

- conf_miso
- conf_mosi
- conf_sclk
- conf_ltch

conf bits
[15 :  0] = LUT content
[16] clk select


---

Shift Register 74HC595D
https://www.digikey.ch/de/products/detail/toshiba-semiconductor-and-storage/74HC595D/5879984

MUX 8:1 74HC151D
https://www.digikey.ch/de/products/detail/toshiba-semiconductor-and-storage/74HC151D/6198926

MUX 2:1 NC7SV157P6X
https://www.digikey.ch/de/products/detail/onsemi/NC7SV157P6X/1049166

D Flip-Flop 1 bit 74AHC1G79GW
https://www.digikey.ch/de/products/detail/nexperia-usa-inc/74AHC1G79GW-125/1229497

Signal Switch 1:1 
https://www.digikey.ch/de/products/filter/logik/signalumschalter-multiplexer-decoder/743?s=N4IgjCBcpgzADFUBjKAzAhgGwM4FMAaEAeygG0QAWeWANggF0iAHAFyhAGVWAnASwB2AcxABfImACcADklIQqSJlyES5EIgbiQAWgBM8xbwCuq0pAoBWEFqI7r0Bemz4i5igaKwQRWj5B6lpqi2n6OfAAmHDpg8BAs7JAg-gCOrACeHLHwiEQZzHgcGDioIUA

https://www.digikey.ch/de/products/filter/schnittstelle/analoge-schalter-multiplexer-demultiplexer/747?s=N4IgjCBcpgnAbBaIDGUBmBDANgZwKYA0IA9lANojwDMALAOwAcIAusQA4AuUIAypwCcAlgDsA5iAC%2B0xOI1hRQaSFjxFSFEAAZW0kAFoATAtRRBAVzVlIlAKw7ieu8iUqCxK5SPFqIYvF8gBjbaMvQ6uv7IQgAmPHpgmhAc3JAgAQCOnACePAmaISDZ7Pg8mLhokpJAA

GPIO Buffer
https://www.digikey.ch/de/products/detail/toshiba-semiconductor-and-storage/74VHCV245FT/5977737



---

Videos


1. Breadboard FPGA Project overview

"the shittiest FPGA ever created"

DIY FPGA with 24 CLB-LUT


2. Configurable Logic Blocks - 4-bit FPGA
- basics of digital logic
- history of FPGAs
- configurable logic functions
- look up table
- SRAM bits as configuraion

3. Interconnect and Routing - 4-bit FPGA
- connecting the LUT
- freedom vs. complexity
- bit shift operation = "free"
- reference current modern FPGA switch boxes
- argument for architecture choice

4. I/O driver - 4-bit FPGA

4. Phase Locked Loop (PLL) - 4-bit FPGA
- clock generation and division

5. System Controller
- bitstream loading
- arduino board

6. Building the FPGA - 4-bit FPGA
- explain modern FPGA architecture (columns)
- 

7. Programming the Field Programmable Gate Array - 4-bit FPGA
- bitstream modification
- upload of bitstream

### Applications

1. Test Application: 4-bit counter - 4-bit FPGA
- 4-bit counter LUT programming
- interconnect routing
- GPIO configuration
- BCD to 7-segment decoder
- change to 8-bit
- explain why 8-bit CPU is "impossible"
- explain the scale and cost of this platform

2. 



