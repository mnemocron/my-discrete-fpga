#!/usr/bin/bash

ghdl --version | head -n 1

# delete
rm -rf *.vcd &
rm -rf *.cf &

# analyze
ghdl -a digital_switch.vhd
ghdl -a tb_digital_switch.vhd

# elaborate
ghdl -e digital_switch
ghdl -e tb_digital_switch

# run
ghdl -r tb_digital_switch --vcd=wave.vcd --stop-time=100ns
gtkwave wave.vcd waveform.gtkw

# delete
rm -rf *.vcd &
rm -rf *.cf &
