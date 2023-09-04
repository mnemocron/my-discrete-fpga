#!/usr/bin/bash

ghdl --version | head -n 1

# delete
rm -rf *.vcd &
rm -rf *.cf &

# analyze
ghdl -a xor_74xx86.vhd
ghdl -a tb_xor_74xx86.vhd

# elaborate
ghdl -e xor_74xx86
ghdl -e tb_xor_74xx86

# run
ghdl -r tb_xor_74xx86 --vcd=wave.vcd --stop-time=100ns
gtkwave wave.vcd waveform.gtkw

# delete
rm -rf *.vcd &
rm -rf *.cf &
