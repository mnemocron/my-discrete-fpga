
#include <SPI.h>
#include <stdio.h>

#define LATCH_PIN 10
#define CLOCK_PIN 7

#define CLB_BYTES (10)
#define BITS_CONFIGURED (2)
#define CLB_OFFSET (8)
#define CLOCK_HALF_PERIOD (1)

char bitstream[CLB_BYTES];
char conf_bits[BITS_CONFIGURED] = {/*reg*/15, /*LUT_A*/16  /*24,25,26,27,28,29,30,31*/};

FILE f_out;
int sput(char c, __attribute__((unused)) FILE* f) {return !Serial.write(c);}

void setup() {
  pinMode(LATCH_PIN, OUTPUT);
  digitalWrite(LATCH_PIN, LOW);
  pinMode(CLOCK_PIN, OUTPUT);
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
  pinMode(A2, INPUT);
  pinMode(A3, INPUT);
  
  Serial.begin(9600);
  fdev_setup_stream(&f_out, sput, nullptr, _FDEV_SETUP_WRITE); // cf https://www.nongnu.org/avr-libc/user-manual/group__avr__stdio.html#gaf41f158c022cbb6203ccd87d27301226
  stdout = &f_out;

  SPI.begin();
  SPI.setBitOrder(LSBFIRST);
  prg_bitstream();

  Serial.println("!");
  Serial.println("LUT_A");
  test_lut(0);
  Serial.println("LUT_B");
  test_lut(1);
  Serial.println("LUT_C");
  test_lut(2);
  Serial.println("LUT_D");
  test_lut(3);

}

void loop() {
  for(int i=0; i<16; i++){
    wrt4(i);
    do_clk();
  }
}

void test_lut(int offset){
  for(int i=0; i<16; i++){
    conf_bits[1] = (16*(offset+1))+i;
    prg_bitstream();
    printf(" %04x |", (1<<i));
    for(int j=0; j<16; j++){
      wrt4(j);
      do_clk();
      int val = rd4();
      if( (val & (1<<offset)) )
        Serial.print(" 1 ");
      else
        Serial.print(" . ");
    }
    Serial.println("");
  }
  Serial.println("");
}

void prg_bitstream(){
  for(int i=0; i<CLB_BYTES; i++)
    bitstream[i] = 0;
  for(int i=0; i<BITS_CONFIGURED; i++){
      char bt = conf_bits[i] - CLB_OFFSET;
      bitstream[bt/8] |= (1 << (bt%8));
      if(i == 1)
        printf("(%d)", conf_bits[i]);
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
