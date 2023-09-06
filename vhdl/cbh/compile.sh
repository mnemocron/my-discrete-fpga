#!/usr/bin/bash

ghdl --version | head -n 1

# delete
rm -rf *.vcd &
rm -rf *.cf &

# analyze
ghdl -a ../cbox/cbox.vhd
ghdl -a ../mux_8_1/mux_74xx151.vhd
ghdl -a ../shift_reg/sr_74xx595.vhd
ghdl -a connection_box_horizontal.vhd
ghdl -a -fsynopsys tb_connection_box_horizontal.vhd

# elaborate
ghdl -e connection_box_horizontal
ghdl -e -fsynopsys tb_connection_box_horizontal

# run
ghdl -r -fsynopsys tb_connection_box_horizontal --vcd=wave.vcd --stop-time=10us
gtkwave wave.vcd waveform.gtkw

# delete
rm -rf *.vcd &
rm -rf *.cf &
