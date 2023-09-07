#!/usr/bin/bash

ghdl --version | head -n 1

# delete
rm -rf *.vcd &
rm -rf *.cf &

# analyze
ghdl -a xpoint_double_thru.vhd
ghdl -a tb_xpoint_double_thru.vhd

# elaborate
ghdl -e xpoint_double_thru
ghdl -e tb_xpoint_double_thru

# run
ghdl -r tb_xpoint_double_thru --vcd=wave.vcd --stop-time=10us
gtkwave wave.vcd waveform.gtkw

# delete
rm -rf *.vcd &
rm -rf *.cf &
