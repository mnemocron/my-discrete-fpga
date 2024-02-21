
#include <SPI.h>
#include <stdio.h>

#define LATCH_PIN 10
#define CLOCK_PIN 8

#define CBh_BYTES (2)
#define CBh_OFFSET (88)
#define CLOCK_HALF_PERIOD (1)

int BITS_CONFIGURED;
char bitstream[CBh_BYTES];
char conf_bits[CBh_BYTES*8]; //  = {/*reg*/15, /*LUT_A*/16  /*24,25,26,27,28,29,30,31*/};

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
  pinMode(6, OUTPUT);
  pinMode(7, OUTPUT);
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

  Serial.println("sel_0");
  test_insel(0);
  Serial.println("sel_1");
  test_insel(1);
  Serial.println("sel_2");
  test_insel(2);
  Serial.println("sel_3");
  test_insel(3);

}

void loop() {
  for(int i=0; i<16; i++){
    wrt4(i);
    do_clk();
  }
}

void test_insel(int offset){
  printf(". \t");
  for(int i=0; i<64; i++){
    printf("%02x ", i);
  }
  printf("\n");
  for(int i=0; i<8; i++){  // 8:1 MUX
    BITS_CONFIGURED = 0;
    int mux_sel[3];
    if(i&1){
      conf_bits[BITS_CONFIGURED++] = CBh_OFFSET + 15-offset*4;
    }
    if(i&2){
      conf_bits[BITS_CONFIGURED++] = CBh_OFFSET + 15-offset*4-1;
    }
    if(i&4){
      conf_bits[BITS_CONFIGURED++] = CBh_OFFSET + 15-offset*4-2;
    }
    prg_bitstream();
    delay(10);

    printf("%d\t", i);
    for(int j=0; j<64; j++){
      wrt4(j);
      int rd = rd4();
      if(rd)
        printf(" %x ", rd);
      else
        printf(" . ");
    }
    printf(" (");
    for(int j=0; j<BITS_CONFIGURED; j++)
      printf("%d,", conf_bits[j]);
    printf(")\n");
  }
}

void prg_bitstream(){
  for(int i=0; i<CBh_BYTES; i++)
    bitstream[i] = 0;
  for(int i=0; i<BITS_CONFIGURED; i++){
      char bt = conf_bits[i] - CBh_OFFSET;
      bitstream[bt/8] |= (1 << (bt%8));
  }
  for(int i=0; i<CBh_BYTES; i++){
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
    
  if( (val & 16) )
    digitalWrite(6, HIGH);
  else
    digitalWrite(6, LOW);

  if( (val & 32) )
    digitalWrite(7, HIGH);
  else
    digitalWrite(7, LOW);
}
