
#include <SPI.h>
#include <stdio.h>

#define LATCH_PIN 10
#define CLOCK_PIN 7

#define CLB_BYTES (10)
#define BITS_CONFIGURED (9*1)
#define CLB_OFFSET (8)
#define CLOCK_HALF_PERIOD (200)

char bitstream[CLB_BYTES];
char conf_bits[BITS_CONFIGURED] = {/*reg*/15, /*LUT_A*/24,25,26,27,28,29,30,31};


void setup() {
  pinMode(LATCH_PIN, OUTPUT);
  pinMode(CLOCK_PIN, OUTPUT);
  digitalWrite(LATCH_PIN, LOW);
  SPI.begin();
  SPI.setBitOrder(LSBFIRST);
  prg_bitstream();
}

void loop() {
  do_clk();
}

void prg_bitstream(){
  for(int i=0; i<BITS_CONFIGURED; i++){
      char bt = conf_bits[i] - CLB_OFFSET;
      bitstream[bt/8] |= (1 << (bt%8));
  }
  for(int i=0; i<CLB_BYTES; i++){
    SPI.transfer(bitstream[i]);
  }
  digitalWrite(LATCH_PIN, HIGH);
  delay(1);
  digitalWrite(LATCH_PIN, LOW);
}

void do_clk(){
  digitalWrite(CLOCK_PIN, LOW);
  delay(CLOCK_HALF_PERIOD);
  digitalWrite(CLOCK_PIN, HIGH);
  delay(CLOCK_HALF_PERIOD);
}
