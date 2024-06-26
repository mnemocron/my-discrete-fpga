/*******************************************************************************
 * @file        diyfpga_user.h
 * @brief       User settings for a user defined FPGA
 * @details     
 * @version     
 * @author      Simon Burkhardt https://github.com/mnemocron
 * @date        2024.04
 * @see         https://github.com/mnemocron/my-discrete-fpga
*******************************************************************************/
#ifndef MY_FPGA_USER_H
#define	MY_FPGA_USER_H

// How many slices does the FPGA have? (2D matrix)
#define N_SLICE_X (1)
#define N_SLICE_Y (3)

#define ENABLE_PRINT_MESSAGES false

#ifdef __cplusplus
 extern "C" {
#endif

void diyfpga_setup();

#ifdef __cplusplus
}
#endif

#endif	/* MY_FPGA_USER_H */