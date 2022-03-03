#include <LiquidCrystal_I2C.h>
#include <Wire.h>
#include <SoftwareSerial.h>
SoftwareSerial mySerial(14, 12); // RX, TX
LiquidCrystal_I2C lcd(0x27, 16, 2);
void setup() {
  Serial.begin(9600);
  mySerial.begin(9600);
  Wire.begin(D2, D1);
  lcd.begin();
}

void loop() {
  if (mySerial.available()) { //Check if there is Incoming Data in the Serial Buffer
    while (mySerial.available()) {  //Keep reading Byte by Byte from the Buffer till the Buffer is empty
      char input = mySerial.read(); //Read 1 Byte of data and store it in a character variable
      lcd.print(input);// Print the stored character variable
      Serial.print(input);
      delay(5); // A small delay
    }
    lcd.setCursor(0, 0);
    Serial.println();
  }
}
