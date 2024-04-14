#!/bin/bash

#mkdir ./temp

gcc generate_vhdl_stimuli.c -o generate_vhdl_stimuli.o -c
gcc diyfpga.c -o diyfpga.o -c
gcc diyfpga_user.c -o diyfpga_user.o -c
gcc -o generate_vhdl_stimuli generate_vhdl_stimuli.o diyfpga.o diyfpga_user.o
rm *.o

./generate_vhdl_stimuli


