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

//WiFi info to authenticate
#define WIFI_SSID "CartToGo"
#define WIFI_PASSWORD "11223344"

//Firebase info to authenticate
#define API_KEY "AIzaSyCFoxsSG6CUrgi5DuiFz6Ph1v2kjdoDbcg"
#define DATABASE_URL "carttogo-411c2-default-rtdb.europe-west1.firebasedatabase.app/" //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app
#define USER_EMAIL "gp04.2022@hotmail.com"
#define USER_PASSWORD "112233"

byte a1 [8] = {4, 4, 4, 4, 4, 0, 0, 0}; //ا
byte t1 [8] = {6, 0, 2, 2, 30, 0, 0, 0}; //ت
byte s1 [8] = {0, 0, 7, 21, 31, 0, 0, 0}; //ص
byte al1 [8] = {5, 5, 21, 21, 29, 0, 0, 0};  //ال

boolean CartConnection = false;
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
bool signupOK = false;
unsigned long sendDataPrevMillis = 0;
float total = 0.0;
SoftwareSerial Gm66Scan(14, 12); // RX, TX for Scanner numbers on the breadboard

LiquidCrystal_I2C lcd(0x27, 16, 2);

void setup() {
  Serial.begin(9600); //To display prininting in laptop on Serial Monitor number 9600
  Gm66Scan.begin(9600);
  Wire.begin(D2, D1); //For the LCD display
  lcd.begin();
  lcd.clear();
  WiFiConnection(); //Begin WiFi Connection
  FirebaseConnection();//Connect and authorize to access firebase
  CartConnection = LoyaltyCardConnection();
  lcd.clear();
  if (CartConnection != false) {
    DisplayStartScanning();
    Serial.println("\nConnection: " + CartConnection);
  }
} //end setup

void DisplayStartScanning() {
  lcd.clear();
  //طباعة عبارة "ابدا المسح" قبل البدأ بمسح أي منتج على شاشاة LCD
  byte al [8] = {5, 5, 5, 5, 29, 0, 0, 0}; //ال
  byte s [8] = {0, 0, 21, 21, 31, 0, 0, 0};      //س
  byte b [8] = {0, 0, 0, 1, 15, 0, 2, 0}; //ب
  byte a [8] = {4, 4, 4, 4, 4, 0, 0, 0}; //ا
  byte d [8] = {0, 0, 14, 2, 3, 14, 0, 0}; //د
  byte h [8] = {0, 0, 12, 4, 7, 12, 8, 12};             //ح
  byte m [8] = {0, 0, 0, 0, 31, 10, 14, 0}; //م
  lcd.createChar(0, a);
  lcd.createChar(1, b);
  lcd.createChar(2, d);
  lcd.createChar(3, al);
  lcd.createChar(4, m);
  lcd.createChar(5, s);
  lcd.createChar(6, h);
  lcd.home();
  lcd.setCursor(15, 0);
  lcd.rightToLeft();
  lcd.write(0);
  lcd.write(1);
  lcd.write(2);
  lcd.write(0);
  lcd.setCursor(11, 0);
  lcd.write(3);
  lcd.write(4);
  lcd.write(5);
  lcd.write(6);
}

void WiFiConnection() {
  lcd.clear();
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  lcd.createChar(0, a1);
  lcd.createChar(1, t1);
  lcd.createChar(2, s1);
  lcd.createChar(3, al1);
  lcd.home();
  lcd.setCursor(15, 0);
  lcd.rightToLeft();
  lcd.write(0); //طباعة عبارة "اتصال" على ال LCD
  lcd.write(1);
  lcd.write(2);
  lcd.write(3);
  int dots = 16;
  Serial.println("Connecting");
  while (WiFi.status() != WL_CONNECTED)
  {
    dots--;
    lcd.setCursor(dots, 1);
    if (dots == -1) {
      for (int n = 16; n > -1; n--)
      { lcd.setCursor(n, 1);
        lcd.print(" ");
      }
      dots = 16;
    }
    lcd.print(".");
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

} //end WiFiConnection

void FirebaseConnection() {
  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);
  config.api_key = API_KEY;

  auth.user.email = USER_EMAIL;

  auth.user.password = USER_PASSWORD;

  config.database_url = DATABASE_URL;

  if (auth.user.email == USER_EMAIL && auth.user.password == USER_PASSWORD) { //Check if the password and email are registered to the firebase
    Serial.println("Signed Up ");
    signupOK = true;
  }
  else {
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }

  config.service_account.json.path = "/carttogo-411c2-default-rtdb-export.json"; //Json File

  config.token_status_callback = tokenStatusCallback; //TokenHelper.h

  config.max_token_generation_retry = 5;

  Firebase.begin(&config, &auth); //Begin authentication

  Firebase.reconnectWiFi(true);

} //end FirebaseConnection

String LoyaltyCard = "";
boolean LoyaltyCardConnection() {
  LoyaltyCard = "";
  char ID;
  boolean con = false;
  total = 0.0;

  lcd.clear();
  //طباعة عبارة "امسح الQR على الشاشة
  byte al [8] = {5, 5, 5, 5, 29, 0, 0, 0}; //ال
  byte s [8] = {0, 0, 21, 21, 31, 0, 0, 0};      //س
  byte a [8] = {4, 4, 4, 4, 4, 4, 0, 0}; //ا
  byte h [8] = {0, 0, 12, 4, 7, 12, 8, 12};    //ح
  byte m [8] = {0, 0, 0, 0, 31, 10, 14, 0}; //م
  byte Q [8] = {12, 18, 18, 18, 18, 26, 22, 15};     //Q
  byte R [8] = {30, 18, 18, 30, 20, 20, 20, 20}; //R

  lcd.createChar(0, a);
  lcd.createChar(1, m);
  lcd.createChar(2, s);
  lcd.createChar(3, h);
  lcd.createChar(4, al);
  lcd.createChar(5, Q);
  lcd.createChar(6, R);


  lcd.home();
  lcd.setCursor(15, 0);
  lcd.rightToLeft();
  lcd.write(0);
  lcd.write(1);
  lcd.write(2);
  lcd.write(3);
  lcd.setCursor(11, 0);
  lcd.write(4);
  lcd.write(6);
  lcd.write(5);

  //lcd.print("Scan your QR");
  while (con == false) {
    while (Gm66Scan.available()) {
      ID = Gm66Scan.read(); //Read 1 Byte of data and store it in a character variable
      LoyaltyCard = LoyaltyCard + ID;
      delay(5); // A small delay
    }
    if (!(LoyaltyCard.equals(""))) {
      lcd.clear();
      byte a [8] = {4, 4, 4, 4, 4, 4, 0, 0}; //ا
      byte n [8] = {1, 0, 1, 1, 31, 0, 0, 0}; //ن
      byte t [8] = {6, 0, 2, 2, 30, 0, 0, 0}; //ت
      byte th [8] = {5, 4, 7, 5, 31, 0, 0, 0};  //ظ
      byte r [8] = {0, 0, 0, 0, 7, 4, 4, 12};  //ر
      lcd.createChar(0, a);
      lcd.createChar(1, n);
      lcd.createChar(2, t);
      lcd.createChar(3, th);
      lcd.createChar(4, r);
      lcd.home();
      lcd.setCursor(15, 0);
      lcd.rightToLeft();
      lcd.write(0);
      lcd.write(1);
      lcd.write(2);
      lcd.write(3);
      lcd.write(4);


      if (LoyaltyCardConnectionFirebase(LoyaltyCard) == true) {
        con = true;
      }
      else {

        //طباعة عبارة "غير مسجلة"
        lcd.clear();
        byte g [8] = {4, 0, 7, 4, 4, 31, 0, 0}; //غ
        byte y [8] = {0, 0, 0, 4, 4, 31, 0, 6};  //ي
        byte r [8] = {0, 0, 0, 0, 4, 7, 8, 16}; //ر
        byte m [8] = {0, 0, 0, 0, 0, 31, 5, 7}; //م
        byte s [8] = {0, 0, 21, 21, 21, 31, 0, 0};  //س
        byte gg [8] = {0, 0, 14, 2, 2, 31, 0, 4};   //ج
        byte t [8] = {13, 1, 29, 21, 29, 7, 0, 0};         //لة

        lcd.createChar(0, g);
        lcd.createChar(1, y);
        lcd.createChar(2, r);
        lcd.createChar(3, m);
        lcd.createChar(4, s);
        lcd.createChar(5, gg);
        lcd.createChar(6, t);

        lcd.home();
        lcd.setCursor(15, 0);
        lcd.rightToLeft();
        lcd.write(0);
        lcd.write(1);
        lcd.write(2);
        lcd.setCursor(11, 0);
        lcd.write(3);
        lcd.write(4);
        lcd.write(5);
        lcd.write(6);



        //lcd.clear();
        //lcd.setCursor(0, 0);
        //lcd.print("LoyaltyCard not");
        //lcd.setCursor(0, 1);
        //lcd.print("found,TryAgain");

        LoyaltyCard = "";
        con = false;
      }
    }
  }
  lcd.clear();
  lcd.print("Connected");
  return true;
}
FirebaseJsonData Carts;
int CartNumber;
FirebaseJsonData UID;
boolean LoyaltyCardConnectionFirebase(String QRid) {
  FirebaseJson json;
  String QRPath = "/QRUidFinder/" + QRid ; //get the UID of the user
  Serial.println("---------Scanned QR---------");
  Serial.println("Path QRPath: " + QRPath);
  if (Firebase.getJSON(fbdo, QRPath) == 1) { //if LoyaltyCard id is avaliable
    Serial.println("Json for " + QRPath + " : " + fbdo.to<FirebaseJson>().raw());
    json = fbdo.to<FirebaseJson>().raw(); //store Json of the scanned LoyaltyCardID
    json.get(UID, "/shopperID");
    if (UID.success) //if fetched database for UID success
    {
      String FutureCartNumber = "/Shopper/" + UID.to<String>() + "/Carts/FutureCartNumber";
      Serial.println("Path FutureCartNumber: " + FutureCartNumber);
      if (Firebase.getInt(fbdo, FutureCartNumber)) { //if UID is avaliable
        CartNumber = fbdo.to<int>();
        Serial.println("Cart Number: " + CartNumber);
        String GetUid = "/Shopper/" + UID.to<String>() + "/Carts";
        Firebase.setInt(fbdo, "/Shopper/" + UID.to<String>() + "/Carts/FutureCartNumber", CartNumber + 1);
        delay(200);
        Serial.print("Add Cart: " + GetUid);
        if (Firebase.setInt(fbdo, GetUid + "/" + CartNumber + "/Total", 0)) {
          if (Firebase.setInt(fbdo, GetUid + "/" + CartNumber + "/Paid", false)) {
            if (Firebase.setBool(fbdo, GetUid + "/ConnectedToCart", true)) {
              if (Firebase.setBool(fbdo, GetUid + "/DeletingProduct", false));
              if (Firebase.setInt(fbdo, GetUid + "/NumOfProducts", 0 ));
              if (Firebase.setInt(fbdo, GetUid + "/Total", 0.0)) { //Set a new total variable for the cart
                return true;
              }
            }
          }
        }
      }
    }
  }
  return false;
}

int count = 0;
int countProducts = 0;
int NumOfProducts = 0;
bool checkDelete = false;
float lastPrice = 0.0;
void loop()
{
  String cartsPath = "/Shopper/" + UID.to<String>() + "/Carts";
  bool ConnectedToCart = true;
  String barcode = "";
  char readBarcode;
  FirebaseJson json;
  FirebaseJsonData price;
  FirebaseJsonData HasOffer;
  FirebaseJsonData name1;
  if (WiFi.status() != 3) { //If WiFi Disconnected
    WiFiConnection(); //Begin WiFi Connection
    FirebaseConnection();//Connect and authorize to access firebase
    DisplayStartScanning();
  }
  if (Firebase.ready() == 1 && signupOK && WiFi.status() == 3) {
    String cartsPath = "/Shopper/" + UID.to<String>() + "/Carts";
    if (Firebase.getBool(fbdo, cartsPath + "/DeletingProduct")) checkDelete = fbdo.to<bool>();
    if (Firebase.getBool(fbdo, cartsPath + "/ConnectedToCart")) ConnectedToCart = fbdo.to<bool>();
    if (countProducts >= 1 && CartConnection != false && checkDelete == true) {
      if (Firebase.getFloat(fbdo, cartsPath + "/Total")) total = fbdo.to<float>();
      if (Firebase.getInt(fbdo, cartsPath + "/NumOfProducts")) NumOfProducts = fbdo.to<int>();
      //if (Firebase.getFloat(fbdo, cartsPath+"/lastPrice")) lastPrice = fbdo.to<float>();
      checkTotalAndCount(total);
    }
    if (!(ConnectedToCart)) {
      LoyaltyCardConnection();
    }
    if (Gm66Scan.available() && CartConnection != false) { //Check if there is Incoming Data in the Serial Buffer

      while (Gm66Scan.available() && CartConnection != false) {  //Keep reading Byte by Byte from the Buffer till the Buffer is empty

        readBarcode = Gm66Scan.read(); //Read 1 Byte of data and store it in a character variable
        barcode = barcode + readBarcode;
        delay(5); // A small delay

      }//end while

      String barcode1 = "/Products/" + barcode; //get to Path Products
      Serial.println("Path barcode: " + barcode1);

      if (Firebase.RTDB.getJSON(&fbdo, barcode1)) { //if barcode that is scanned is available in the database
        json = fbdo.to<FirebaseJson>().raw(); //store Json of the scanned barcode
        FirebaseJsonData getQuan;
        FirebaseJson jsonQuan;
        int Qunatity = 0;
        json.get(HasOffer, "/Offer");
        if (HasOffer.to<bool>() == true) {
          json.get(price, "/PriceAfterOffer"); //If it has an offer take the offer price
        }
        else {
          json.get(price, "/Price");
        }
        json.get(name1, "/Name");
        json.get(getQuan, "/Quantity");
        Qunatity = getQuan.to<int>();

        /*
          if (getQuan.to<int>() != 1 && (Firebase.RTDB.getJSON(&fbdo, PathCart))==false) {
          json.set("/Quantity", 1);
          }
        */
        Serial.println("Json for " + barcode + " : " + fbdo.to<FirebaseJson>().raw());
        if (price.success && name1.success && Qunatity > 0) //if fetched database for price and name is available
        {
          Qunatity--;
          json.set("/Quantity", Qunatity);
          Firebase.setJSON(fbdo, "Products/" + barcode, json);
          json.set("/Barcode", barcode);
          json.remove("/Quantity");

          countProducts++;
          NumOfProducts++;
          lcd.clear();
          total = total + price.to<float>();
          Serial.println(
            "Product: " + name1.to<String>()
            + " Price: " + price.to<float>()
            + " Total: " + String(total));
          //طباعة السعر واجمالي السعر على شاشة LCD
          byte al [8] = {5, 5, 5, 5, 29, 0, 0, 0}; //ال
          byte s [8] = {0, 21, 21, 21, 31, 0, 0, 0}; //س
          byte aen [8] = {0, 0, 14, 14, 31, 0, 0, 0}; //ع
          byte r [8] = {0, 0, 0, 0, 3, 4, 8, 0}; //ر
          byte a [8] = {4, 4, 4, 4, 7, 0, 0, 0};  //أ`
          byte jem [8] = {0, 0, 12, 3, 30, 0, 4, 0}; //جـ
          byte m [8] = {0, 0, 0, 0, 31, 10, 10, 14}; //م
          byte ly [8] = {1, 1, 1, 1, 23, 28, 0, 12}; //لي


          lcd.createChar(0, al);
          lcd.createChar(1, s);
          lcd.createChar(2, aen);
          lcd.createChar(3, r);
          lcd.createChar(4, a);
          lcd.createChar(5, jem);
          lcd.createChar(6, m);
          lcd.createChar(7, ly);

          lcd.home();
          lcd.setCursor(15, 0);
          lcd.rightToLeft();
          lcd.write(0);
          lcd.write(1);
          lcd.write(2);
          lcd.write(3);

          lcd.setCursor(15, 1);
          lcd.write(0);
          lcd.write(4);
          lcd.write(5);
          lcd.write(6);
          lcd.write(4);
          lcd.write(7);
          lcd.leftToRight();
          lcd.setCursor(11, 0);
          lcd.print(":");
          lcd.setCursor(0, 0);
          lcd.print(String(price.to<float>()));
          lcd.setCursor(9, 1);
          lcd.print(":");
          lcd.setCursor(0, 1);
          lcd.print(String(total));
          /*
            if (Firebase.RTDB.getJSON(&fbdo, PathCart)==1) { //if there is a duplicate item then "true"
            FirebaseJsonData quan;
            json.get(quan, "/Quantity");
            Serial.println(quan.to<int>());
            json.set("/Quantity", quan.to<int>() + 1);
            }
          */

          String PathCart = "/Shopper/" + UID.to<String>() + "/Carts/" + CartNumber + "/" + countProducts;
          Serial.println("ShopperID: " + cartsPath);
          Firebase.setInt(fbdo, cartsPath + "/Total", total);
          Firebase.setInt(fbdo, cartsPath + "/NumOfProducts", NumOfProducts );
          Firebase.setJSON(fbdo, PathCart, json);


        }
      }

      else { //If barcode that is scanned is not available in the database

        //اذا المنتج غير مسجل تظهر عبارة "غير مسجل" على شاشاة LCD
        Serial.println(fbdo.errorReason().c_str());
        lcd.clear();
        byte g [8] = {4, 0, 7, 4, 4, 31, 0, 0}; //غ
        byte y [8] = {0, 0, 0, 4, 4, 31, 0, 6};  //ي
        byte r [8] = {0, 0, 0, 0, 4, 7, 8, 16}; //ر
        byte m [8] = {0, 0, 0, 0, 0, 31, 5, 7}; //م
        byte s [8] = {0, 0, 21, 21, 21, 31, 0, 0};  //س
        byte gg [8] = {0, 0, 14, 2, 2, 31, 0, 4};   //ج
        byte l [8] = {4, 4, 4, 4, 4, 23, 20, 28}; //ل


        lcd.createChar(0, g);
        lcd.createChar(1, y);
        lcd.createChar(2, r);
        lcd.createChar(3, m);
        lcd.createChar(4, s);
        lcd.createChar(5, gg);
        lcd.createChar(6, l);
        lcd.home();
        lcd.setCursor(15, 0);
        lcd.rightToLeft();
        lcd.write(0);
        lcd.write(1);
        lcd.write(2);
        lcd.setCursor(11, 0);
        lcd.write(3);
        lcd.write(4);
        lcd.write(5);
        lcd.write(6);
      }
      lcd.setCursor(0, 0);
      Serial.println();
    }// end Scanner Available
  }// end firebase ready
}//end loop
void checkTotalAndCount(float totalPrice) {
  lcd.clear();
  //طباعة السعر واجمالي السعر على شاشة LCD
  byte al [8] = {5, 5, 5, 5, 29, 0, 0, 0}; //ال
  byte a [8] = {4, 4, 4, 4, 7, 0, 0, 0};  //أ`
  byte jem [8] = {0, 0, 12, 3, 30, 0, 4, 0}; //جـ
  byte m [8] = {0, 0, 0, 0, 31, 10, 10, 14}; //م
  byte ly [8] = {1, 1, 1, 1, 23, 28, 0, 12}; //لي

  lcd.createChar(0, al);
  lcd.createChar(4, a);
  lcd.createChar(5, jem);
  lcd.createChar(6, m);
  lcd.createChar(7, ly);

  lcd.home();
  lcd.rightToLeft();

  lcd.setCursor(15, 1);
  lcd.write(0);
  lcd.write(4);
  lcd.write(5);
  lcd.write(6);
  lcd.write(4);
  lcd.write(7);
  lcd.leftToRight();
  lcd.setCursor(9, 1);
  lcd.print(":");
  lcd.setCursor(0, 1);
  lcd.print(String(totalPrice));

}
