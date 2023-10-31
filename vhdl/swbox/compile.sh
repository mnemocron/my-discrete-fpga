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
ghdl -a sw_box.vhd
ghdl -a bus_io_dummy.vhd
ghdl -a -fsynopsys tb_sw_box.vhd

# elaborate
ghdl -e sw_box
ghdl -e -fsynopsys tb_sw_box

# run
ghdl -r -fsynopsys tb_sw_box --vcd=wave.vcd --stop-time=10us
gtkwave wave.vcd waveform.gtkw

# delete
rm -rf *.vcd &
rm -rf *.cf &
