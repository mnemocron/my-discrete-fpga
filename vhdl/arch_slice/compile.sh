#!/usr/bin/bash

ghdl --version | head -n 1

# delete
rm -rf *.vcd &
rm -rf *.cf &

# analyze
ghdl -a ../digital_switch/digital_switch.vhd
#ghdl -a ../xpoint_thru/xpoint_thru.vhd
ghdl -a ../newsw/newsw.vhd
ghdl -a ../shift_reg/sr_74xx595.vhd
ghdl -a ../cbox/cbox.vhd
ghdl -a ../ff_reg/ff_74xx175.vhd
ghdl -a ../mux_2_1/mux_74LVC1G157.vhd
ghdl -a ../mux_4_1/mux_74xx153.vhd
ghdl -a ../mux_8_1/mux_74xx151.vhd
ghdl -a ../mux_quad_2_1/mux_74xx157.vhd
ghdl -a ../xor/xor_74xx86.vhd

ghdl -a ../swbox/sw_box.vhd
ghdl -a ../cbv/connection_box_vertical.vhd
ghdl -a ../clb/clb_slice.vhd
ghdl -a ../cbh/connection_box_horizontal.vhd

ghdl -a fpga_arch_tile.vhd
ghdl -a -fsynopsys tb_fpga_arch_tile.vhd

# elaborate
ghdl -e fpga_arch_tile
ghdl -e -fsynopsys tb_fpga_arch_tile

# run
ghdl -r -fsynopsys tb_fpga_arch_tile --vcd=wave.vcd --stop-time=10us
gtkwave wave.vcd waveform.gtkw

# delete
rm -rf *.vcd &
rm -rf *.cf &
