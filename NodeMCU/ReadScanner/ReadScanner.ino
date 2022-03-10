#include <ArduinoJson.h>
#include <LiquidCrystal_I2C.h>
#include <Wire.h>
#include <SoftwareSerial.h>
#if defined(ESP32)
#include <WiFi.h>
#include <FirebaseESP32.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>
#endif

//Provide the token generation process info.
#include <addons/TokenHelper.h>

//Provide the RTDB payload printing info and other helper functions.
#include <addons/RTDBHelper.h>

/* 1. Define the WiFi credentials */
#define WIFI_SSID "Haya"
#define WIFI_PASSWORD "Haya0409"

//For the following credentials, see examples/Authentications/SignInAsUser/EmailPassword/EmailPassword.ino

/* 2. Define the API Key */
#define API_KEY "AIzaSyCFoxsSG6CUrgi5DuiFz6Ph1v2kjdoDbcg"

/* 3. Define the RTDB URL */
#define DATABASE_URL "carttogo-411c2-default-rtdb.europe-west1.firebasedatabase.app/" //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app

/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "reemaazaid@gmail.com"
#define USER_PASSWORD "112233"

//Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;
unsigned long sendDataPrevMillis = 0;
SoftwareSerial mySerial(14, 12); // RX, TX
LiquidCrystal_I2C lcd(0x27, 16, 2);
void setup() {
  Serial.begin(9600);
  mySerial.begin(9600);
  Wire.begin(D2, D1);
  lcd.begin();
  lcd.clear();
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h

  //Or use legacy authenticate method
  //config.database_url = DATABASE_URL;
  //config.signer.tokens.legacy_token = "<database secret>";

  Firebase.begin(&config, &auth);

  //Comment or pass false value when WiFi reconnection will control by your code or third party library
  Firebase.reconnectWiFi(true);
}
int total = 0;
void loop()
{ String barcode = "";
  char readBarcode;
  FirebaseJson json;
  FirebaseJsonData price;
  FirebaseJsonData name1;
  if (mySerial.available()) { //Check if there is Incoming Data in the Serial Buffer
    while (mySerial.available()) {  //Keep reading Byte by Byte from the Buffer till the Buffer is empty
      readBarcode = mySerial.read(); //Read 1 Byte of data and store it in a character variable
      barcode = barcode + readBarcode;
      delay(5); // A small delay
    }
    String barcode1 = "/barcode/" + barcode;
    Serial.println("Path barcode: " + barcode1);
    if (Firebase.RTDB.getJSON(&fbdo, barcode1)) {
      Serial.println("Json for " + barcode + " : " + fbdo.to<FirebaseJson>().raw());
      json = fbdo.to<FirebaseJson>().raw();
      json.get(price, "/price");
      json.get(name1, "/name");
      if (price.success && name1.success)
      { lcd.clear();
        total = total + price.to<int>();
        Serial.println("Item: " + name1.to<String>() + " Price: " + price.to<int>() + " Total: " + String(total));
        lcd.setCursor(0, 0);
        lcd.print(name1.to<String>());
        lcd.setCursor(0, 1);
        lcd.print("Price:" + price.to<String>());
        lcd.setCursor(8, 1);
        lcd.print("Total:" + String(total));
      }
    }
    else {
      Serial.println(fbdo.errorReason().c_str());
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("This product is");
      lcd.setCursor(1, 1);
      lcd.print("not registered");
    }
    lcd.setCursor(0, 0);
    Serial.println();
  }

}
