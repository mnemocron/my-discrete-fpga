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
#include <SPI.h>
#include <stdio.h>
#include "diyfpga.h"
#include "diyfpga_user.h"

/* SPI pinout
 * 13 -> SCLK
 * 12 -> MISO
 * 11 -> MOSI 
 */
#define LATCH_PIN 10
#define CLOCK_PIN 8
#define RST_PIN 9

#define CLOCK_HALF_PERIOD 50

FILE f_out;
int sput(char c, __attribute__((unused)) FILE* f) {return !Serial.write(c);}

fpga_t myfpga;  // fpga object: edit settings in diyfpga_user.h

void setup() {
  // todo: find out what the SPI is doing on reset. this could potentially be dangerous for the FPGA
  setup_printf();
  setup_gpio();

  /* Program the FPGA functionality in myfpga_user.cpp */
  diyfpga_setup(); 
  create_bitstream(&myfpga);
  program_bitstream(myfpga.bitstream, N_BYTES_BITSTREAM);


  for(int i=0; i<N_BYTES_SLICE; i++){
    printf("%02X\n", myfpga.slice[0][0].bitstream[i]);
  }
}

void loop() {
  do_clk();
}

void setup_printf(){
  Serial.begin(9600);
  fdev_setup_stream(&f_out, sput, nullptr, _FDEV_SETUP_WRITE); // cf https://www.nongnu.org/avr-libc/user-manual/group__avr__stdio.html#gaf41f158c022cbb6203ccd87d27301226
  stdout = &f_out;
}

void setup_gpio(){
  pinMode(LATCH_PIN, OUTPUT);
  digitalWrite(LATCH_PIN, LOW);
  pinMode(CLOCK_PIN, OUTPUT);
  pinMode(RST_PIN, OUTPUT);
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
  pinMode(A2, INPUT);
  pinMode(A3, INPUT);

  SPI.begin();
  SPI.setBitOrder(LSBFIRST);
}

void program_bitstream(char* bin, int len){
  digitalWrite(RST_PIN, LOW);

  for(int i=0; i<len; i++){
    SPI.transfer(*bin++);
  }
  digitalWrite(LATCH_PIN, HIGH);
  delay(1);
  digitalWrite(LATCH_PIN, LOW);

  delay(50);
  digitalWrite(RST_PIN, HIGH);
  delay(50);
}

void do_clk(){
  digitalWrite(CLOCK_PIN, LOW);
  delay(CLOCK_HALF_PERIOD);
  digitalWrite(CLOCK_PIN, HIGH);
  delay(CLOCK_HALF_PERIOD);
}

int rd4(){
  int val = 0;
  if(digitalRead(A0))
    val |= (1<<0);
  if(digitalRead(A1))
    val |= (1<<1);
  if(digitalRead(A2))
    val |= (1<<2);
  if(digitalRead(A3))
    val |= (1<<3);
  return val;
}

void wrt4(int val){

  if( (val & 1) )
    digitalWrite(2, HIGH);
  else
    digitalWrite(2, LOW);

  if( (val & 2) )
    digitalWrite(3, HIGH);
  else
    digitalWrite(3, LOW);

  if( (val & 4) )
    digitalWrite(4, HIGH);
  else
    digitalWrite(4, LOW);

  if( (val & 8) )
    digitalWrite(5, HIGH);
  else
    digitalWrite(5, LOW);
}
