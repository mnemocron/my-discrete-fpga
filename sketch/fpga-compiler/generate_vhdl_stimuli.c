/*******************************************************************************
 * @file        create_vhdl_stimuli.c
 * @brief       Compiles the program in diyfpga_user.c to a bitstream readable
 *              by the VHDL testbench
 * @details     
 * @version     
 * @author      Simon Burkhardt https://github.com/mnemocron
 * @date        2024.04
 * @see         https://github.com/mnemocron/my-discrete-fpga
*******************************************************************************/
#if !defined(__AVR_ATmega328P__) // exclude everything for the Arduino compiler

#include <stdio.h>
#include "diyfpga.h"
#include "diyfpga_user.h"

fpga_t myfpga;

int main()
{
    printf("compiling...\n");
    /* Program the FPGA functionality in myfpga_user.cpp */
    diyfpga_setup(); 
    create_bitstream(&myfpga);

    return 0;
}

#endif
