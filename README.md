
# CartToGo 
## 🛒Introduction
<div align="center">
 <a href="https://github.com/GP2022KSU/2022-GP1-04">
<img float="left" alt="CartToGo" height="200" src="https://user-images.githubusercontent.com/80041251/156749999-9e298d8f-6897-4a20-b623-45a96fc664f0.png" style="float:'left'">
 </a>
 </div>
 <p><b>CartToGo</b> is an <b>IoT-based smart system</b> that is connected to an <b>iOS</b> mobile application, used by supermarket shoppers to reduce their waiting time in the queue lines and that’s done by enabling them to scan each product’s barcode to display its price and total price on the LCD display as well as the iOS mobile application.</p>
<p align="right">
 نظام CartToGo مبني على انترنت الأشياء، وهو نظام ذكي مرتبط بتطبيق هاتف يعمل بنظام تشغيل iOS، يستخدم من قبل المتسوقين في مركز التسوق لتقليل وقتهم في طوابير الشراء، وذلك عن طريق السماح لهم بقراءة سعر المنتج واجمال سعر المنتجات وعرضها على شاشة LCD و تطبيق الهاتف.
</p>

## 💻 Technology Used 
### <img width=22px src="https://user-images.githubusercontent.com/80041251/161458756-13fbc1d7-3bd3-41d3-a49e-6aff7bd23502.png"> IoT NodeMCU ESP8266 Microcontroller
- <img width=32px src="https://user-images.githubusercontent.com/80041251/161459850-51aeb8de-d98e-465f-8380-c1820d1afe9d.png">&nbsp; <b>C++</b> 
### <img width=22px src="https://user-images.githubusercontent.com/80041251/161458313-29aaced6-b88e-4478-a317-be89617e1b40.png"> IOS mobile application

- <img width=32px src="https://user-images.githubusercontent.com/80041251/161459767-fb4ea2cd-3965-438a-820c-52923e9fef61.png">&nbsp; <b>Dart</b>
-   <img width=35px src="https://raw.githubusercontent.com/github/explore/80688e429a7d4ef2fca1e82350fe8e3517d3494d/topics/python/python.png">&nbsp; <b>Python</b>

## ⚙️ Dependencies


### Needed dependencies for NodeMCU ESP8266 Microcontroller

- [ArdunioIDE](https://www.arduino.cc/en/software) Version `1.7` or higher is required.
- Libraires needed in ArdunioIDE are:
  | Library name| By |
  | --- | --- |
  | [Firebase ESP8266 Client](https://github.com/mobizt/Firebase-ESP8266) | Mobizt Version `3.9.5` |
  | [LiquidCrystal I2C](https://github.com/fdebrabander/Arduino-LiquidCrystal-I2C-library) | Frank de Brabander Version `1.1.2`|
  
 
 ### Needed dependencies for IOS mobile application
 - [Flutter](https://docs.flutter.dev/get-started/install) Version `2.10`
 - [Visual Studio Code](https://code.visualstudio.com/download) OR [Android Studio](https://developer.android.com/studio)
 - then install the flutter extension in `Extensions` for Visual, and for Android in `File > Settings > Plugins`
 
 ## ▶️ Usage
 
 ### Usage for NodeMCU ESP8266 Microcontroller
 1- First copy or download the `ProductScanner.ino` file
   ```
   https://github.com/GP2022KSU/2022-GP1-04/blob/main/NodeMCU/ProductsScanner/ProductsScanner.ino
   ```
   
 2- Then open the code in Arduino and install the required libraries as mentioned in the dependencies [above](#%EF%B8%8F-dependencies)  
 
 3- After that adjust the RX and TX for the Scanner that is connected to the breadboard
  ```
   SoftwareSerial mySerial(14 , 12); // RX, TX for Scanner numbers on the breadboard
   ```
  4- Compile and Upload the code to the NodeMCU through available COM port
  <br>
  ![image](https://user-images.githubusercontent.com/80041251/161467132-43f86722-b242-4a0a-916c-bc46d328f866.png)

 ### Usage for IOS mobile application
 1- Install the dependencies mentioned [above](#%EF%B8%8F-dependencies) 
 
 2- Fetch latest source code from main branch then go to `CartToGo` folder
 ```
   https://github.com/GP2022KSU/2022-GP1-04.git
   ```
 
 3- Run the app with Android Studio or VS Code. Or the command line:

```
cd CartToGo
flutter pub get
flutter run
```


## 🎯 Features

* **A complete IoT smart system that includes hardware and an application connected to it**

* **Realtime database for fast retrieval of the scanned products**

* **An interface for 3 users, Cashier - Shopper - Admin**

* **Display all previous invoices**

* **Add/Delete products in the shopping cart**

* **Display the product location**

* **Supports Recommender system (An AI algorithm) for products with the same category with less prices and products that have offers based on previous purchases**

## 👩‍💻 Contributors
<div align="center">
<a href="https://github.com/Haya-Alhomaidhi"><img src="https://avatars.githubusercontent.com/u/90135883?v=4" title="Haya" width="80" height="80"></a>
<a href="https://github.com/ReemaAlzaid"><img src="https://avatars.githubusercontent.com/u/80041251?v=4" title="Reema" width="80" height="80"></a>
 <a href="https://github.com/ALJAWHARA-ALBAHLAL"><img src="https://avatars.githubusercontent.com/u/90135922?v=4" title="Aljawhara" width="80" height="80"></a>
 <a href="https://github.com/saraabanmi"><img src="https://avatars.githubusercontent.com/u/90135877?v=4" title="Sara" width="80" height="80"></a>
</div>
 
