#!/usr/bin/bash

ghdl --version | head -n 1

# delete
rm -rf *.vcd &
rm -rf *.cf &

# analyze
ghdl -a newsw.vhd
ghdl -a tb_newsw.vhd

# elaborate
ghdl -e newsw
ghdl -e tb_newsw

# run
ghdl -r tb_newsw --vcd=wave.vcd --stop-time=1us
gtkwave wave.vcd waveform.gtkw

# delete
rm -rf *.vcd &
rm -rf *.cf &
