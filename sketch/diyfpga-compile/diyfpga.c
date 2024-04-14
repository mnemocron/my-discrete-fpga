/*******************************************************************************
 * @file        diyfpga.c
 * @brief       Rudimentary compiler that translates features from a struct into
 *              a binary bitstream for the FPGA
 * @details     
 * @version     
 * @author      Simon Burkhardt https://github.com/mnemocron
 * @date        2024.04
 * @see         https://github.com/mnemocron/my-discrete-fpga
*******************************************************************************/

#include <stdio.h>
#include "diyfpga.h"

void SET_BIT_IN_BITSTREAM(slice_t* s, int b){
  s->bitstream[b/8] |= (1 << (b%8));
#if ENABLE_PRINT_MESSAGES
  printf("%d, ", b);
#endif
}

void SET_CBH_INMUX_BITSTREAM(slice_t* s){
  cbh_t* cbh = &s->cbh;
  for(int i=0; i<4; i++){
    int muxsel = (int)cbh->sel[i];
    int bitoffset = 103-(i*4);
    if(muxsel & (1<<0))
      SET_BIT_IN_BITSTREAM(s, bitoffset);
    if(muxsel & (1<<1))
      SET_BIT_IN_BITSTREAM(s, bitoffset-1);
    if(muxsel & (1<<2))
      SET_BIT_IN_BITSTREAM(s, bitoffset-2);
  }
}

void SET_CLB_INMUX_BITSTREAM(slice_t* s){
  clb_t* clb = &s->clb;
  for(int i=0; i<4; i++){
    int muxsel = (int)clb->in_mux[i];
    int bitoffset = 87-(i*2);
    if(muxsel & (1<<0))
      SET_BIT_IN_BITSTREAM(s, bitoffset);
    if(muxsel & (1<<1))
      SET_BIT_IN_BITSTREAM(s, bitoffset-1);
  }
}

void SET_CLB_LUT_BITSTREAM(slice_t* s){
  clb_t* clb = &s->clb;
  for(int i=0; i<4; i++){
    int bitoffset = 79 - (3-i)*16;
    uint16_t lut4 = clb->lut[i];
    for(int j=0; j<16; j++){
      if(lut4 & (1<<j))
        SET_BIT_IN_BITSTREAM(s, bitoffset-j); // todo, bit reverse?
    }
#if ENABLE_PRINT_MESSAGES
    printf("\n");
#endif
  }
}

int create_bitstream(fpga_t* fpga){
  fpga->Nx = N_SLICE_X;
  fpga->Ny = N_SLICE_Y;
  
#if ENABLE_PRINT_MESSAGES
  printf("create_bitstream()\n");
#endif

  for(int ix=0; ix<fpga->Nx; ix++){
    for(int iy=0; iy<fpga->Ny; iy++){
      slice_t* slc = &fpga->slice[ix][iy];
      // SW
      sw_t* sw = &slc->sw;
      for(int i=0; i<4; i++){
        if(sw->xp[i])
          SET_BIT_IN_BITSTREAM(slc, 111-i); 
        if(sw->north[i])
          SET_BIT_IN_BITSTREAM(slc, 115-i); 
        if(sw->south[i])
          SET_BIT_IN_BITSTREAM(slc, 119-i);
        if(sw->east[i])
          SET_BIT_IN_BITSTREAM(slc, 123-i);
        if(sw->west[i])
          SET_BIT_IN_BITSTREAM(slc, 127-i);
      }
      for(int i=4; i<6; i++){ 
        if(sw->north[i])
          SET_BIT_IN_BITSTREAM(slc, 133-i+4);
        if(sw->south[i])
          SET_BIT_IN_BITSTREAM(slc, 135-i+4);
        if(sw->east[i])
          SET_BIT_IN_BITSTREAM(slc, 129-i+4);
        if(sw->west[i])
          SET_BIT_IN_BITSTREAM(slc, 131-i+4);
      }
      if(sw->xp[4])
        SET_BIT_IN_BITSTREAM(slc, 107); 
      if(sw->xp[5])
        SET_BIT_IN_BITSTREAM(slc, 104); 
      if(sw->ns4_to_ew5)
        SET_BIT_IN_BITSTREAM(slc, 105);
      if(sw->ns5_to_ew4)
        SET_BIT_IN_BITSTREAM(slc, 106);
#if ENABLE_PRINT_MESSAGES
      printf("\n");
#endif

      // CBh
      cbh_t* cbh = &slc->cbh;
      if(cbh->ce)
        SET_BIT_IN_BITSTREAM(slc, 88);
      if(cbh->cin)
        SET_BIT_IN_BITSTREAM(slc, 92);
      if(cbh->cout_n)
        SET_BIT_IN_BITSTREAM(slc, 96);
      if(cbh->cout_s)
        SET_BIT_IN_BITSTREAM(slc, 100);
      SET_CBH_INMUX_BITSTREAM(slc);
#if ENABLE_PRINT_MESSAGES
      printf("\n");
#endif

      // CBv
      cbv_t* cbv = &slc->cbv;
      for(int i=0; i<4; i++){
        if(cbv->bus[i])
          SET_BIT_IN_BITSTREAM(slc, 7-i);
      }
      if(cbv->bus_0_to_5)
        SET_BIT_IN_BITSTREAM(slc, 3);
      if(cbv->bus_1_to_4)
        SET_BIT_IN_BITSTREAM(slc, 2);
      if(cbv->bus_2_to_5)
        SET_BIT_IN_BITSTREAM(slc, 1);
      if(cbv->bus_3_to_4)
        SET_BIT_IN_BITSTREAM(slc, 0);
#if ENABLE_PRINT_MESSAGES
      printf("\n");
#endif

      // CLB
      clb_t* clb = &slc->clb;
      SET_CLB_LUT_BITSTREAM(slc);
      for(int i=0; i<4; i++){
        if(clb->reg[i])
          SET_BIT_IN_BITSTREAM(slc, 15-i);
      }
      if(clb->sum)
        SET_BIT_IN_BITSTREAM(slc, 11);
      if(clb->clk_en)
        SET_BIT_IN_BITSTREAM(slc, 8);
      if(clb->clk_sel == 1)  // TODO: boundry check for clock selection [0,1]
        SET_BIT_IN_BITSTREAM(slc, 10);
      
      // Bitstream
      int offset = N_BYTES_SLICE * (iy + (fpga->Ny * ix));
      // but with SPI the slice order is reversed, therefore reverse the slice order:
      offset = N_BYTES_SLICE * ( (fpga->Ny * fpga->Nx) - (iy + (fpga->Ny * ix)) -1 );
      for(int k=0; k<N_BYTES_SLICE; k++)
        fpga->bitstream[offset+k] = slc->bitstream[k];
    }
  }
#if ENABLE_PRINT_MESSAGES
  printf("\n");
#endif

  return 0;
}


