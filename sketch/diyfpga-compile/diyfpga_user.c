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

  /*
  myfpga.slice[0][1].sw.north[0] = true;
  myfpga.slice[0][1].sw.north[1] = true;
  myfpga.slice[0][1].sw.north[2] = true;
  myfpga.slice[0][1].sw.north[3] = true;
  myfpga.slice[0][1].sw.west[0] = true;
  myfpga.slice[0][1].sw.west[1] = true;
  myfpga.slice[0][1].sw.west[2] = true;
  myfpga.slice[0][1].sw.west[3] = true;
  myfpga.slice[0][1].sw.xp[0] = true;
  myfpga.slice[0][1].sw.xp[1] = true;
  myfpga.slice[0][1].sw.xp[2] = true;
  myfpga.slice[0][1].sw.xp[3] = true;
  myfpga.slice[0][1].cbh.sel[0] = BUS_3;
  myfpga.slice[0][1].cbh.sel[1] = BUS_2;
  myfpga.slice[0][1].cbh.sel[2] = BUS_1;
  myfpga.slice[0][1].cbh.sel[3] = BUS_0;
  //myfpga.slice[0][1].clb.reg[0] = true;
  //myfpga.slice[0][1].clb.reg[1] = true;
  myfpga.slice[0][1].cbv.bus_0_to_5 = true;
  myfpga.slice[0][1].cbv.bus_1_to_4 = true;

  myfpga.slice[0][1].clb.lut[0] = 0x9208;  // fizz
  myfpga.slice[0][1].clb.lut[1] = 0x8420;  // buzz

  myfpga.slice[0][1].sw.north[4] = true;
  myfpga.slice[0][1].sw.north[5] = true;
  myfpga.slice[0][1].sw.south[4] = true;
  myfpga.slice[0][1].sw.south[5] = true;
  */

  myfpga.slice[0][1].sw.north[0] = true;
  myfpga.slice[0][1].sw.north[1] = true;
  myfpga.slice[0][1].sw.north[2] = true;
  myfpga.slice[0][1].sw.north[3] = true;
  myfpga.slice[0][1].sw.west[0] = true;
  myfpga.slice[0][1].sw.west[1] = true;
  myfpga.slice[0][1].sw.west[2] = true;
  myfpga.slice[0][1].sw.west[3] = true;
  myfpga.slice[0][1].sw.xp[0] = true;
  myfpga.slice[0][1].sw.xp[1] = true;
  myfpga.slice[0][1].sw.xp[2] = true;
  myfpga.slice[0][1].sw.xp[3] = true;
  myfpga.slice[0][1].clb.reg[0] = true;
  myfpga.slice[0][1].clb.reg[1] = true;
  myfpga.slice[0][1].clb.reg[2] = true;
  myfpga.slice[0][1].clb.reg[3] = true;
  myfpga.slice[0][1].clb.sum = true;
  myfpga.slice[0][0].clb.clk_sel = 0;
  myfpga.slice[0][0].clb.clk_en = false;
  myfpga.slice[0][1].clb.in_mux[0] = SUM_INPUT;
  myfpga.slice[0][1].clb.in_mux[1] = SUM_INPUT;
  myfpga.slice[0][1].clb.in_mux[2] = SUM_INPUT;
  myfpga.slice[0][1].clb.in_mux[3] = SUM_INPUT;
  myfpga.slice[0][1].clb.lut[0] = 0x6;
  myfpga.slice[0][1].clb.lut[1] = 0x6;
  myfpga.slice[0][1].clb.lut[2] = 0x6;
  myfpga.slice[0][1].clb.lut[3] = 0x6;
  myfpga.slice[0][1].cbv.bus[0] = true;
  myfpga.slice[0][1].cbv.bus[1] = true;
  myfpga.slice[0][1].cbv.bus[2] = true;
  myfpga.slice[0][1].cbv.bus[3] = true;

  myfpga.slice[0][2].clb.reg[0] = true;
  myfpga.slice[0][2].clb.reg[1] = true;
  myfpga.slice[0][2].clb.reg[2] = true;
  myfpga.slice[0][2].clb.reg[3] = true;
  myfpga.slice[0][2].clb.clk_sel = 0;
  myfpga.slice[0][2].clb.clk_en = false;
  myfpga.slice[0][2].clb.sum = false;

  myfpga.slice[0][2].clb.lut[0] = 0x1; // 0x00FF;
  myfpga.slice[0][2].clb.lut[1] = 0x0; // 0x0FF0; 
  myfpga.slice[0][2].clb.lut[2] = 0x0; // 0x3CCC; 
  myfpga.slice[0][2].clb.lut[3] = 0x0; // 0x6AAA; 

  myfpga.slice[0][2].cbv.bus[0] = true;
  myfpga.slice[0][2].cbv.bus[1] = true;
  myfpga.slice[0][2].cbv.bus[2] = true;
  myfpga.slice[0][2].cbv.bus[3] = true;

  myfpga.slice[0][2].sw.xp[0] = true;
  myfpga.slice[0][2].sw.xp[1] = true;
  myfpga.slice[0][2].sw.xp[2] = true;
  myfpga.slice[0][2].sw.xp[3] = true;
  myfpga.slice[0][2].sw.south[0] = true;
  myfpga.slice[0][2].sw.south[1] = true;
  myfpga.slice[0][2].sw.south[2] = true;
  myfpga.slice[0][2].sw.south[3] = true;
  myfpga.slice[0][2].sw.west[0] = true;
  myfpga.slice[0][2].sw.west[1] = true;
  myfpga.slice[0][2].sw.west[2] = true;
  myfpga.slice[0][2].sw.west[3] = true;

}


