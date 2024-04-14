/*******************************************************************************
 * @file        diyfpga_user.c
 * @brief       This is where the user can write a program for the FPGA
 * @details     
 * @version     
 * @author      Simon Burkhardt https://github.com/mnemocron
 * @date        2024.04
 * @see         https://github.com/mnemocron/my-discrete-fpga
*******************************************************************************/
#include <stdio.h>
#include "diyfpga.h"

extern fpga_t myfpga;

void diyfpga_setup(){
  myfpga.slice[0][0].clb.reg[0] = true;
  myfpga.slice[0][0].clb.reg[1] = true;
  myfpga.slice[0][0].clb.reg[2] = true;
  myfpga.slice[0][0].clb.reg[3] = true;
  myfpga.slice[0][0].clb.clk_sel = 0;
  myfpga.slice[0][0].clb.clk_en = false;
  myfpga.slice[0][0].clb.sum = false;

  myfpga.slice[0][0].clb.lut[0] = 0x00FF;
  myfpga.slice[0][0].clb.lut[1] = 0x0FF0; 
  myfpga.slice[0][0].clb.lut[2] = 0x3CCC; 
  myfpga.slice[0][0].clb.lut[3] = 0x6AAA; 

  myfpga.slice[0][0].cbv.bus[0] = true;
  myfpga.slice[0][0].cbv.bus[1] = true;
  myfpga.slice[0][0].cbv.bus[2] = true;
  myfpga.slice[0][0].cbv.bus[3] = true;

  myfpga.slice[0][0].sw.xp[0] = true;
  myfpga.slice[0][0].sw.xp[1] = true;
  myfpga.slice[0][0].sw.xp[2] = true;
  myfpga.slice[0][0].sw.xp[3] = true;
  myfpga.slice[0][0].sw.south[0] = true;
  myfpga.slice[0][0].sw.south[1] = true;
  myfpga.slice[0][0].sw.south[2] = true;
  myfpga.slice[0][0].sw.south[3] = true;
  myfpga.slice[0][0].sw.west[0] = true;
  myfpga.slice[0][0].sw.west[1] = true;
  myfpga.slice[0][0].sw.west[2] = true;
  myfpga.slice[0][0].sw.west[3] = true;

  myfpga.slice[0][0].cbh.sel[0] = BUS_3;
  myfpga.slice[0][0].cbh.sel[1] = BUS_2;
  myfpga.slice[0][0].cbh.sel[2] = BUS_1;
  myfpga.slice[0][0].cbh.sel[3] = BUS_0;
  
}


