#include <LiquidCrystal_I2C.h>
#include <Wire.h>
#include <SoftwareSerial.h>
#include <Arduino.h>
#if defined(ESP32)
#include <WiFi.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#endif
#include <Firebase_ESP_Client.h>


//Provide the token generation process info.
#include "addons/TokenHelper.h"
//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

// Insert Firebase project API Key
#define API_KEY "AIzaSyCFoxsSG6CUrgi5DuiFz6Ph1v2kjdoDbcg"

// Insert Authorized Email and Corresponding Password
#define DATABASE_URL "carttogo-411c2-default-rtdb.europe-west1.firebasedatabase.app/"

//Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
unsigned long sendDataPrevMillis = 0;
int count = 0;
bool signupOK = false;
SoftwareSerial mySerial(14, 12); // RX, TX
LiquidCrystal_I2C lcd(0x27, 16, 2);
void setup() {
  Serial.begin(9600);
  mySerial.begin(9600);
  Wire.begin(D2, D1);
  lcd.begin();
  // Connect to WiFi
  WiFi.begin(".", "11223344");
  // while wifi not connected yet, print '.'
  // then after it connected, get out of the loop
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  //print a new line, then print WiFi connected and the IP address
  Serial.println("");
  Serial.println("WiFi connected");
  // Print the IP address
  Serial.println(WiFi.localIP());

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Sign up */
  if (Firebase.signUp(&config, &auth, "reemaazaid@gmail.com", "112233")) {
    Serial.println("ok");
    signupOK = true;
  }
  else {
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }

  // Assign the callback function for the long running token generation task
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h

  // Initialize the library with the Firebase authen and config
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void loop() {

  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 15000 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();
    if (mySerial.available()) { //Check if there is Incoming Data in the Serial Buffer
      while (mySerial.available()) {  //Keep reading Byte by Byte from the Buffer till the Buffer is empty
        int readBarcode = mySerial.read(); //Read 1 Byte of data and store it in a character variable
        String itemName = " ";
        //String barcode = " "+readBarcode;
        if (itemName = Firebase.RTDB.getString(&fbdo, "barcode/6251001213010/name")) {
          Serial.println("PASSED");
          Serial.println("PATH: " + fbdo.dataPath());
          Serial.println("TYPE: " + fbdo.dataType());
        }
        else {
          Serial.println("FAILED");
          Serial.println("REASON: " + fbdo.errorReason());
        }
        lcd.print(itemName);// Print the stored character variable
        Serial.print(itemName);
        delay(5); // A small delay
      }
      lcd.setCursor(0, 0);
      Serial.println();
    }
    // Write an Float number on the database path test/float
    // Write an Int number on the database path test/int
    if (Firebase.RTDB.setInt(&fbdo, "test/int", count)) {
      Serial.println("PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    }
    else {
      Serial.println("FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }
    count++;

    // Write an Float number on the database path test/float
    if (Firebase.RTDB.setFloat(&fbdo, "test/float", 0.01 + random(0, 100))) {
      Serial.println("PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    }
    else {
      Serial.println("FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }
  }
}
