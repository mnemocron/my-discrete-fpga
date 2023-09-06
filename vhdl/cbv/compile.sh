#!/usr/bin/bash

ghdl --version | head -n 1

# delete
rm -rf *.vcd &
rm -rf *.cf &

# analyze
ghdl -a ../cbox/cbox.vhd
ghdl -a ../shift_reg/sr_74xx595.vhd
ghdl -a connection_box_vertical.vhd
ghdl -a -fsynopsys tb_connection_box_vertical.vhd

# elaborate
ghdl -e connection_box_vertical
ghdl -e -fsynopsys tb_connection_box_vertical

# run
ghdl -r -fsynopsys tb_connection_box_vertical --vcd=wave.vcd --stop-time=10us
gtkwave wave.vcd waveform.gtkw

# delete
rm -rf *.vcd &
rm -rf *.cf &
