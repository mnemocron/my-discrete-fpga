#!/usr/bin/bash

ghdl --version | head -n 1

# delete
rm -rf *.vcd &
rm -rf *.cf &

# analyze
ghdl -a -fsynopsys tb_file_io.vhd

# elaborate
ghdl -e -fsynopsys tb_file_io 

# run
ghdl -r -fsynopsys tb_file_io --vcd=wave.vcd --stop-time=1us
gtkwave wave.vcd waveform.gtkw

# delete
rm -rf *.vcd &
rm -rf *.cf &
