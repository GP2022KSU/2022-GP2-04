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
#include <addons/TokenHelper.h>

#include <addons/RTDBHelper.h>

#define WIFI_SSID "RZ New"
#define WIFI_PASSWORD "11223344"

//For the following credentials, see examples/Authentications/SignInAsUser/EmailPassword/EmailPassword.ino


#define API_KEY "AIzaSyCFoxsSG6CUrgi5DuiFz6Ph1v2kjdoDbcg"


#define DATABASE_URL "carttogo-411c2-default-rtdb.europe-west1.firebasedatabase.app/" //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app

#define USER_EMAIL "reemaazaid@gmail.com"
#define USER_PASSWORD "112233"

//Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
bool signupOK = false;
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
  lcd.setCursor(0, 0);
  lcd.print("Connecting");
  int dots = -1;
  while (WiFi.status() != WL_CONNECTED)
  {
    dots++;
    lcd.setCursor(dots, 1);
    lcd.print(".");
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();
  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);
  config.api_key = API_KEY;
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;
  config.database_url = DATABASE_URL;
    if (auth.user.email==USER_EMAIL&&auth.user.password==USER_PASSWORD) {
    Serial.println("ok");
    signupOK = true;
  }
  else {
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Connected");
  delay(3000);
  lcd.setCursor(0, 0);
  lcd.print("Scan an Item");
}
float total = 0;
void loop()
{
  String barcode = "";
  char readBarcode;
  FirebaseJson json;
  FirebaseJsonData price;
  FirebaseJsonData name1;
  if (Firebase.ready()==1 && signupOK) {
    if (mySerial.available()) { //Check if there is Incoming Data in the Serial Buffer
      while (mySerial.available()) {  //Keep reading Byte by Byte from the Buffer till the Buffer is empty
        readBarcode = mySerial.read(); //Read 1 Byte of data and store it in a character variable
        barcode = barcode + readBarcode;
        delay(5); // A small delay
      }
      String barcode1 = "/Products/" + barcode;
      Serial.println("Path barcode: " + barcode1);
      if (Firebase.RTDB.getJSON(&fbdo, barcode1)) {
        Serial.println("Json for " + barcode + " : " + fbdo.to<FirebaseJson>().raw());
        json = fbdo.to<FirebaseJson>().raw();
        json.get(price, "/Price");
        json.get(name1, "/Name");
        if (price.success && name1.success)
        { lcd.clear();
          total = total + price.to<float>();
          Serial.println("Item: " + name1.to<String>() + " Price: " + price.to<int>() + " Total: " + String(total));
          lcd.setCursor(3, 0);
          lcd.print("Price:" + price.to<String>());
          //lcd.print(name1.to<String>());
          //lcd.setCursor(1, 1);
          //lcd.print("Price:" + price.to<String>());
          lcd.setCursor(1, 1);
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
}
