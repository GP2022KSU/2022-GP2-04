import 'package:flutter/material.dart';
import 'package:carttogo/main.dart';
import 'package:carttogo/Pages/Navigation.dart';

class AdminAddProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
              //background lines
              const Image(image: AssetImage('assets/images/blueCart.png')),

              //اسم المنتج
              const Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "إسم المنتج",
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    hintText: "أدخل إسم المنتج",
                    hintStyle: TextStyle(fontSize: 18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(width: 2, color: appColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),

              //الباركود نمبر يضيفه من خلال المسح ويتم تعبئة الانبوت
              const Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: " الرمز الشريطي للمنتج",
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    hintText: " ادخل الرمز الشريطي للمنتج",
                    hintStyle: TextStyle(fontSize: 18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(width: 2, color: appColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),

              //العلامة التجارية
              const Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "العلامة التجارية",
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    hintText: "أدخل العلامة التجارية",
                    hintStyle: TextStyle(fontSize: 18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(width: 2, color: appColor),
                    ),
                  ),
                ),
              ),

              //الفئة
              const Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "الفئة",
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    hintText: "أدخل الفئة ",
                    hintStyle: TextStyle(fontSize: 18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(width: 2, color: appColor),
                    ),
                  ),
                ),
              ),

              //السعر
              const Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "السعر",
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    hintText: "أدخل السعر ",
                    hintStyle: TextStyle(fontSize: 18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(width: 2, color: appColor),
                    ),
                  ),
                ),
              ),

              //الكمية
              const Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "الكمية",
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    hintText: "أدخل الكمية ",
                    hintStyle: TextStyle(fontSize: 18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(width: 2, color: appColor),
                    ),
                  ),
                ),
              ),

              // الحجم
              const Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "الحجم",
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    hintText: "أدخل الحجم ",
                    hintStyle: TextStyle(fontSize: 18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(width: 2, color: appColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40.0),

              //login button
              ElevatedButton(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(8.0),
                      textStyle: MaterialStateProperty.all(const TextStyle(
                          fontSize: 20, fontFamily: 'CartToGo')),
                      fixedSize: MaterialStateProperty.all(const Size(270, 50)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                      backgroundColor: MaterialStateProperty.all(appColor),
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () {
                    // مبدئي
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Navi();
                    }));
                  },
                  child: const Text('إضافةالمنتج')),
            ]),
          ),
        ));
  }
}
