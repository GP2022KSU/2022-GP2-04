import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:carttogo/main.dart';
import 'package:carttogo/Pages/Navigation.dart';
import 'dart:async';
import 'package:flutter/services.dart';


class RealtimeDatabaseInsert extends StatefulWidget {
  RealtimeDatabaseInsert({Key? key}) : super(key: key);

  @override
  RealtimeDatabaseInsertState createState() => RealtimeDatabaseInsertState();
}


class RealtimeDatabaseInsertState extends State<RealtimeDatabaseInsert> {
  var pNameController = new TextEditingController();
  var pbarcodeController = new TextEditingController();
  var pBrandController = new TextEditingController();
  var pPriceController = new TextEditingController();
  var pCategoryController = new TextEditingController();
  var pQuantityController = new TextEditingController();
  var pSizeController = new TextEditingController();
  var pLocationController = new TextEditingController();


  final databaseRef= FirebaseDatabase.instance.reference();


//class AdminAddProduct extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: Colors.white24,
          title: Text(
            "إضافة منتج جديد",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'CartToGo',
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

              //اسم المنتج
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: pNameController,
                      decoration: const InputDecoration(
                        labelText: "الإسم",
                        labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                        hintText: "أدخل إسم المنتج",
                        hintStyle: TextStyle(fontSize: 18),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(width: 2, color: appColor),
                        ),
                      ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء كتابة إسم المنتج';
                          }
                          return null;
                        },
                        onChanged: (value) {}
                    ),
                  ),
                  const SizedBox(height: 15),

              // الباركود نمبر
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ], // Only numbers can be entered
                        //  obscureText: true,
                      //  obscureText: true,
                      controller: pbarcodeController,
                      decoration: const InputDecoration(
                        labelText: "الرمز الشريطي",
                        labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                        hintText: "أدخل الرمز الشريطي للمنتج ",
                        hintStyle: TextStyle(fontSize: 18),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(width: 2, color: appColor),
                        ),
                      ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء كتابة الرمز الشريطي للمنتج';
                          }
                          return null;
                        },
                        onChanged: (value) {}
                    ),
                  ),
                  const SizedBox(height: 15),

              //العلامة التجارية
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: pBrandController,
                      decoration: const InputDecoration(
                        labelText: "العلامة التجارية",
                        labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                        hintText: "أدخل العلامة التجارية للمنتج",
                        hintStyle: TextStyle(fontSize: 18),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(width: 2, color: appColor),
                        ),
                      ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء كتابة العلامة التجارية المنتج';
                          }
                          return null;
                        },
                        onChanged: (value) {}
                    ),
                  ),
                  const SizedBox(height: 15),

              //الفئة
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: pCategoryController,
                      decoration: const InputDecoration(
                        labelText: "الفئة",
                        labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                        hintText: "أدخل الفئة، تصنيف المنتج ",
                        hintStyle: TextStyle(fontSize: 18),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(width: 2, color: appColor),
                        ),
                      ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء كتابة فئة المنتج';
                          }
                          return null;
                        },
                        onChanged: (value) {}
                    ),
                  ),

                  const SizedBox(height: 15),

              //السعر
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ], // Only numbers can be entered
                      //  obscureText: true,
                      controller: pPriceController,
                      decoration: const InputDecoration(
                        labelText: "السعر",
                        labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                        hintText: "أدخل سعر المنتج ",
                        hintStyle: TextStyle(fontSize: 18),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(width: 2, color: appColor),
                        ),
                      ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء كتابة سعر المنتج';
                          }
                          return null;
                        },
                        onChanged: (value) {}
                    ),
                  ),
                  const SizedBox(height: 15),

              //الكمية
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ], // Only numbers can be entered
                      //  obscureText: true,
                      controller: pQuantityController,
                      decoration: const InputDecoration(
                        labelText: "الكمية",
                        labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                        hintText: "أدخل كمية المنتج ",
                        hintStyle: TextStyle(fontSize: 18),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(width: 2, color: appColor),
                        ),
                      ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء كتابة كمية المنتج';
                          }
                          return null;
                        },
                        onChanged: (value) {}
                    ),
                  ),
                  const SizedBox(height: 15),

              // الحجم
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: pSizeController,
                      decoration: const InputDecoration(
                        labelText: "الحجم",
                        labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                        hintText: "أدخل حجم، وزن المنتج ",
                        hintStyle: TextStyle(fontSize: 18),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(width: 2, color: appColor),
                        ),
                      ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء كتابة حجم المنتج';
                          }
                          return null;
                        },
                        onChanged: (value) {}
                    ),
                  ),
                  const SizedBox(height: 15),

                  // الموقع
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: pLocationController,
                      decoration: const InputDecoration(
                        labelText: "الموقع",
                        labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                        hintText: "أدخل موقع المنتج ",
                        hintStyle: TextStyle(fontSize: 18),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(width: 2, color: appColor),
                        ),
                      ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء كتابة موقع المنتج';
                          }
                          return null;
                        },
                        onChanged: (value) {}
                    ),
                  ),
                  const SizedBox(height: 15),

                  SizedBox(height: 20,
                  ),
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
                       if(pNameController.text.isNotEmpty &&
                            pbarcodeController.text.isNotEmpty && //number?
                            pBrandController.text.isNotEmpty &&
                            pCategoryController.text.isNotEmpty &&
                            pPriceController.text.isNotEmpty && //number?
                            pQuantityController.text.isNotEmpty && //number?
                            pSizeController.text.isNotEmpty &&
                            pLocationController.text.isNotEmpty){

                     insertData(pNameController.text, pbarcodeController.text,
                         pBrandController.text, pCategoryController.text,
                       pPriceController.text,  pQuantityController.text,
                         pSizeController.text,pLocationController.text);
                   }
                      },
                      child: const Text('إضافة المنتج')),

            ]
            ),
          ),)
    );
  }
void insertData(String name, String barcode, String brand, String category , String price, String quantity, String size , String location){
  // String key = databaseRef.child("Products").push().key;
  //databaseRef.child("Products").child(key).set({//product as parent
  databaseRef.child("Products").child("$barcode").set({//product as parent
    //  'ID' : key,//uni ID
      'Name': name,
      'barcodeNumber' : barcode,
      'Brand' : brand,
      'Category' :category,
      'Price' : price,
      'Quantity' :quantity,
      'Size' : size,
      'Location': location,
    });
   pNameController.clear();
   pbarcodeController.clear();
   pBrandController.clear();
   pCategoryController.clear();
   pPriceController.clear();
   pQuantityController.clear();
   pSizeController.clear();
   pLocationController.clear();
}
}


