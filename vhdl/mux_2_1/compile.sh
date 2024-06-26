#!/usr/bin/bash

ghdl --version | head -n 1

# delete
rm -rf *.vcd &
rm -rf *.cf &

# analyze
ghdl -a mux_74LVC1G157.vhd
ghdl -a tb_mux_74LVC1G157.vhd

# elaborate
ghdl -e mux_74LVC1G157
ghdl -e tb_mux_74LVC1G157

# run
ghdl -r tb_mux_74LVC1G157 --vcd=wave.vcd --stop-time=100ns
gtkwave wave.vcd waveform.gtkw

# delete
rm -rf *.vcd &
rm -rf *.cf &
