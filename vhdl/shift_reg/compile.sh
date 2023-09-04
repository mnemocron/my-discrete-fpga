#!/usr/bin/bash

ghdl --version | head -n 1

# delete
rm -rf *.vcd &
rm -rf *.cf &

# analyze
ghdl -a sr_74xx595.vhd
ghdl -a tb_sr_74xx595.vhd

# elaborate
ghdl -e sr_74xx595
ghdl -e tb_sr_74xx595

# run
ghdl -r tb_sr_74xx595 --vcd=wave.vcd --stop-time=300ns
gtkwave wave.vcd waveform.gtkw

# delete
rm -rf *.vcd &
rm -rf *.cf &
