#!/usr/bin/bash

ghdl --version | head -n 1

# delete
rm -rf *.vcd &
rm -rf *.cf &

# analyze
ghdl -a cbox.vhd
ghdl -a -fsynopsys tb_cbox.vhd

# elaborate
ghdl -e cbox
ghdl -e -fsynopsys tb_cbox

# run
ghdl -r -fsynopsys tb_cbox --vcd=wave.vcd --stop-time=200ns
gtkwave wave.vcd waveform.gtkw

# delete
rm -rf *.vcd &
rm -rf *.cf &
