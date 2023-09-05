#!/usr/bin/bash

ghdl --version | head -n 1

# delete
rm -rf *.vcd &
rm -rf *.cf &

# analyze
ghdl -a ../ff_reg/ff_74xx175.vhd
ghdl -a ../mux_2_1/mux_74LVC1G157.vhd
ghdl -a ../mux_4_1/mux_74xx153.vhd
ghdl -a ../mux_8_1/mux_74xx151.vhd
ghdl -a ../mux_quad_2_1/mux_74xx157.vhd
ghdl -a ../shift_reg/sr_74xx595.vhd
ghdl -a ../xor/xor_74xx86.vhd
ghdl -a clb_slice.vhd
ghdl -a -fsynopsys tb_clb_slice.vhd

# elaborate
ghdl -e clb_slice
ghdl -e -fsynopsys tb_clb_slice

# run
ghdl -r -fsynopsys tb_clb_slice --vcd=wave.vcd --stop-time=10us
gtkwave wave.vcd waveform.gtkw

# delete
rm -rf *.vcd &
rm -rf *.cf &
