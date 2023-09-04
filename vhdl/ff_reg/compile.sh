#!/usr/bin/bash

ghdl --version | head -n 1

# delete
rm -rf *.vcd &
rm -rf *.cf &

# analyze
ghdl -a ff_74xx175.vhd
ghdl -a tb_ff_74xx175.vhd

# elaborate
ghdl -e ff_74xx175
ghdl -e tb_ff_74xx175

# run
ghdl -r tb_ff_74xx175 --vcd=wave.vcd --stop-time=100ns
gtkwave wave.vcd waveform.gtkw

# delete
rm -rf *.vcd &
rm -rf *.cf &
