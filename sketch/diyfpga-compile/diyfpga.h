/*******************************************************************************
 * @file        diyfpga.h
 * @brief       Rudimentary compiler that translates features from a struct into
 *              a binary bitstream for the FPGA
 * @details     
 * @version     
 * @author      Simon Burkhardt https://github.com/mnemocron
 * @date        2024.04
 * @see         https://github.com/mnemocron/my-discrete-fpga
*******************************************************************************/
#include <stdbool.h>
#include <stdint.h>
#include "diyfpga_user.h"

#ifndef MY_FPGA_H
#define	MY_FPGA_H

#define N_BYTES_CLB (10)
#define N_BYTES_CBV (1)
#define N_BYTES_CBH (2)
#define N_BYTES_CSW (4)
#define N_BYTES_SLICE (N_BYTES_CLB + N_BYTES_CBV + N_BYTES_CBH + N_BYTES_CSW)
#define N_BYTES_BITSTREAM (N_BYTES_SLICE * N_SLICE_X * N_SLICE_Y)

#define BYTE_TO_BINARY_PATTERN "%c%c%c%c%c%c%c%c"
#define BYTE_TO_BINARY(byte)  \
  ((byte) & 0x01 ? '1' : '0'), \
  ((byte) & 0x02 ? '1' : '0'), \
  ((byte) & 0x04 ? '1' : '0'), \
  ((byte) & 0x08 ? '1' : '0'), \
  ((byte) & 0x10 ? '1' : '0'), \
  ((byte) & 0x20 ? '1' : '0'), \
  ((byte) & 0x40 ? '1' : '0'), \
  ((byte) & 0x80 ? '1' : '0') 

#ifdef __cplusplus
 extern "C" {
#endif

typedef enum {
  GND = 0,
  VCC = 1,
  BUS_5 = 2,
  BUS_4 = 3,
  BUS_3 = 4,
  BUS_2 = 5,
  BUS_1 = 6,
  BUS_0 = 7
} cbh_select_t;

typedef struct {
  cbh_select_t sel[4];
  bool ce;
  bool cin;
  bool cout_n;
  bool cout_s;
} cbh_t;

typedef struct {
  bool bus[4];
  bool bus_0_to_5;
  bool bus_2_to_5;
  bool bus_1_to_4;
  bool bus_3_to_4;
} cbv_t;

typedef struct {
  bool north[6];
  bool south[6];
  bool east[6];
  bool west[6];
  bool xp[6];
  bool ns4_to_ew5;
  bool ns5_to_ew4;
} sw_t;

typedef enum {
  PRE = 0,
  LUT_EXPAND = 1,
  SUM_INPUT = 2,
  SUM_INPUT_REVERSED = 3
} insel_t;

typedef struct {
  bool reg[4];
  bool sum;
  int clk_sel;
  bool clk_en;
  uint16_t lut[4];
  insel_t in_mux[4];
} clb_t;

typedef struct {
  int pos_x;
  int pos_y;
  clb_t clb;
  cbv_t cbv;
  cbh_t cbh;
  sw_t  sw;
  char bitstream[N_BYTES_SLICE];
} slice_t;

typedef struct {
  slice_t slice[N_SLICE_X][N_SLICE_Y];
  int Nx;
  int Ny;
  char bitstream[N_BYTES_BITSTREAM];
} fpga_t;

int create_bitstream(fpga_t* fpga);

#ifdef __cplusplus
}
#endif

#endif	/* MY_FPGA_H */