#!/usr/bin/bash

ghdl --version | head -n 1

# delete
rm -rf *.vcd &
rm -rf *.cf &

# analyze
ghdl -a mux_74xx153.vhd
ghdl -a tb_mux_74xx153.vhd

# elaborate
ghdl -e mux_74xx153
ghdl -e tb_mux_74xx153

# run
ghdl -r tb_mux_74xx153 --vcd=wave.vcd --stop-time=100ns
gtkwave wave.vcd waveform.gtkw

# delete
rm -rf *.vcd &
rm -rf *.cf &
