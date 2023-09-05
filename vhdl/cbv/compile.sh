#!/usr/bin/bash

ghdl --version | head -n 1

# delete
rm -rf *.vcd &
rm -rf *.cf &

# analyze
ghdl -a ../digital_switch/digital_switch.vhd
ghdl -a connection_box_vertical.vhd.vhd
ghdl -a -fsynopsys tb_connection_box_vertical.vhd.vhd

# elaborate
ghdl -e connection_box_vertical.vhd
ghdl -e -fsynopsys tb_connection_box_vertical.vhd

# run
ghdl -r -fsynopsys tb_connection_box_vertical.vhd --vcd=wave.vcd --stop-time=10us
gtkwave wave.vcd waveform.gtkw

# delete
rm -rf *.vcd &
rm -rf *.cf &
