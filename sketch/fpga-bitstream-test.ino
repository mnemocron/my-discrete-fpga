
#define LATCH_PIN 10
#define CLOCK_PIN 2

#define CLB_BYTES (10)
#define BITS_CONFIGURED (9*2)
#define CLB_OFFSET (8)

char bitstream[CLB_BYTES];

#include <SPI.h>

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(LATCH_PIN, OUTPUT);
  pinMode(CLOCK_PIN, OUTPUT);
  digitalWrite(LED_BUILTIN, LOW);
  digitalWrite(LATCH_PIN, LOW);
  SPI.begin();
  SPI.setBitOrder(LSBFIRST);

  char conf_bits[BITS_CONFIGURED] = {/*reg*/15,14, /*LUT_A*/24,25,26,27,28,29,30,31, /*LUT_B*/40,41,42,43,44,45,46,47;
  
  for(int i=0; i<BITS_CONFIGURED; i++){
      char bt = conf_bits[i] - CLB_OFFSET;
      bitstream[bt/8] |= (1 << (bt%8));
  }

  digitalWrite(LED_BUILTIN, LOW);
  delay(500);
  for(int i=0; i<CLB_BYTES; i++){
    SPI.transfer(bitstream[i]);
    if(i%2)
      digitalWrite(LED_BUILTIN, HIGH);
    else
      digitalWrite(LED_BUILTIN, LOW);
  }
  digitalWrite(LATCH_PIN, HIGH);
  delay(100);
  digitalWrite(LATCH_PIN, LOW);
  digitalWrite(LED_BUILTIN, HIGH);

}

void loop() {
  digitalWrite(CLOCK_PIN, LOW);
  digitalWrite(LED_BUILTIN, LOW);
  delay(500);
  digitalWrite(CLOCK_PIN, HIGH);
  digitalWrite(LED_BUILTIN, HIGH);
  delay(500);
}
