import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carttogo/main.dart';
import 'package:flutter/services.dart';
import 'package:carttogo/Pages/productsListAdmin.dart';
import 'package:carttogo/scanner_icons.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:developer';

class AddNewProduct extends StatefulWidget {
  String scanData;
  AddNewProduct(this.scanData);
  @override
  State<AddNewProduct> createState() => AddNewProductState(scanData);
}

class AddNewProductState extends State<AddNewProduct> {
  late String scanData;
  AddNewProductState(this.scanData);
  @override

  //create add new product form
  final _formKey = GlobalKey<FormState>();
  var pbarcodeController = new TextEditingController();
  var pNameController = new TextEditingController();
  var pBrandController = new TextEditingController();
  var pPriceController = new TextEditingController();
  var pCategoryController = new TextEditingController();
  var pQuantityController = new TextEditingController();
  var pSizeController = new TextEditingController();
  var pLocationController = new TextEditingController();
  var pLocController = new TextEditingController();
  final databaseRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    setState(() => pbarcodeController.text = scanData);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: appColor,
          ),
          backgroundColor: Colors.white,
          title: const Text("اضافة منتج جديد",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Product's barcode number
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                                // #1 the barcode number can be added by typing
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ], // numbers keyboard to ensure only numbers can be entered
                                controller: pbarcodeController,
                                decoration: InputDecoration(
                                  labelText: "الرمز الشريطي",
                                  labelStyle: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  hintText: "أدخل الرمز الشريطي للمنتج ",
                                  hintStyle: TextStyle(fontSize: 18),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide:
                                        BorderSide(width: 2, color: appColor),
                                  ),

                                  // #2 the barcode number can be added by scanning
                                  // click on the scan icon to open the scanner to scan the product's barcode
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const scanProductBarcode(),
                                      ));
                                    },
                                    icon: const Icon(Scanner.scanner),
                                    color: appColor,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء كتابة الرمز الشريطي للمنتج';
                                  }
                                  if (value.contains(RegExp(r'[A-Z]')) &&
                                      value.contains(RegExp(r'[a-z]'))) {
                                    return 'الرمز الشريطي للمنتج يجب ان لا يحتوي على احرف';
                                  }
                                  return null;
                                },
                                onChanged: (value) {}),
                          ),
                          const SizedBox(height: 14),

                          // Product's name
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: pNameController,
                                decoration: const InputDecoration(
                                  labelText: "الإسم",
                                  labelStyle: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  hintText: "أدخل إسم المنتج",
                                  hintStyle: TextStyle(fontSize: 18),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide:
                                        BorderSide(width: 2, color: appColor),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء كتابة إسم المنتج';
                                  }
                                  if (value.contains(RegExp(r'[0-9]'))) {
                                    return 'اسم المنتج يجب ان لا يحتوي على ارقام';
                                  }
                                  return null;
                                },
                                onChanged: (value) {}),
                          ),
                          const SizedBox(height: 14),

                          // Product's location
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: pLocController,
                                decoration: const InputDecoration(
                                  labelText: "الموقع",
                                  labelStyle: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  hintText: "أدخل موقع المنتج",
                                  hintStyle: TextStyle(fontSize: 18),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide:
                                        BorderSide(width: 2, color: appColor),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء كتابة موقع المنتج';
                                  }
                                  return null;
                                },
                                onChanged: (value) {}),
                          ),
                          const SizedBox(height: 14),

                          // Product's brand
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: pBrandController,
                                decoration: const InputDecoration(
                                  labelText: "العلامة التجارية",
                                  labelStyle: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  hintText: "أدخل العلامة التجارية للمنتج",
                                  hintStyle: TextStyle(fontSize: 18),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide:
                                        BorderSide(width: 2, color: appColor),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء كتابة العلامة التجارية المنتج';
                                  }
                                  if (value.contains(RegExp(r'[0-9]'))) {
                                    return 'العلامة التجارية للمنتج يجب ان لا تحتوي على ارقام';
                                  }
                                  return null;
                                },
                                onChanged: (value) {}),
                          ),
                          const SizedBox(height: 14),

                          // Product's category
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: pCategoryController,
                                decoration: const InputDecoration(
                                  labelText: "الفئة",
                                  labelStyle: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  hintText: "أدخل الفئة، تصنيف المنتج ",
                                  hintStyle: TextStyle(fontSize: 18),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide:
                                        BorderSide(width: 2, color: appColor),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء كتابة فئة المنتج';
                                  }
                                  if (value.contains(RegExp(r'[0-9]'))) {
                                    return 'فئة المنتج يجب ان لا تحتوي على ارقام';
                                  }
                                  return null;
                                },
                                onChanged: (value) {}),
                          ),

                          const SizedBox(height: 14),

                          //Product's price
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'(^\d*\.?\d*)'))
                                ], // Only numbers can be entered
                                controller: pPriceController,
                                decoration: const InputDecoration(
                                  labelText: "السعر",
                                  labelStyle: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  hintText: "أدخل سعر المنتج ",
                                  hintStyle: TextStyle(fontSize: 18),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide:
                                        BorderSide(width: 2, color: appColor),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء كتابة سعر المنتج';
                                  }
                                  if (value.contains(RegExp(r'[A-Z]')) &&
                                      value.contains(RegExp(r'[a-z]'))) {
                                    return 'سعر المنتج يجب ان لا يحتوي على احرف';
                                  }
                                  return null;
                                },
                                onChanged: (value) {}),
                          ),
                          const SizedBox(height: 14),

                          // Product's quantity
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ], // Only numbers can be entered
                                controller: pQuantityController,
                                decoration: const InputDecoration(
                                  labelText: "الكمية",
                                  labelStyle: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  hintText: "أدخل كمية المنتج ",
                                  hintStyle: TextStyle(fontSize: 18),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide:
                                        BorderSide(width: 2, color: appColor),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء كتابة كمية المنتج';
                                  }
                                  if (value.contains(RegExp(r'[A-Z]')) &&
                                      value.contains(RegExp(r'[a-z]'))) {
                                    return 'كمية المنتج يجب ان لا تحتوي على احرف';
                                  }
                                  return null;
                                },
                                onChanged: (value) {}),
                          ),
                          const SizedBox(height: 14),

                          // Product's size
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: pSizeController,
                                decoration: const InputDecoration(
                                  labelText: "الحجم",
                                  labelStyle: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  hintText: "أدخل حجم، وزن المنتج ",
                                  hintStyle: TextStyle(fontSize: 18),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide:
                                        BorderSide(width: 2, color: appColor),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء كتابة حجم المنتج';
                                  }
                                  return null;
                                },
                                onChanged: (value) {}),
                          ),

                          const SizedBox(height: 14),
                          SizedBox(
                            height: 11,
                          ),

                          // start of "add new product" button
                          ElevatedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(8.0),
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'CartToGo')),
                                  fixedSize: MaterialStateProperty.all(
                                      const Size(270, 50)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(90.0))),
                                  backgroundColor:
                                      MaterialStateProperty.all(appColor),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white)),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (pbarcodeController.text.isNotEmpty &&
                                      pNameController.text.isNotEmpty &&
                                      pBrandController.text.isNotEmpty &&
                                      pCategoryController.text.isNotEmpty &&
                                      pPriceController.text.isNotEmpty &&
                                      pQuantityController.text.isNotEmpty &&
                                      pSizeController.text.isNotEmpty &&
                                      pLocController.text.isNotEmpty) {
                                    addProduct(
                                        pbarcodeController.text,
                                        pNameController.text,
                                        pBrandController.text,
                                        pCategoryController.text,
                                        pPriceController.text,
                                        pQuantityController.text,
                                        pSizeController.text,
                                        pLocController.text);
                                  }
                                  // if the form completed correctly،
                                  //navigate to "ProductsListAdmin" to show the product in the products' list
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ProductsListAdmin();
                                  }));
                                }
                              },
                              child: const Text('إضافة المنتج')),
                          // end of "add new product" button
                        ]))
                // end of add new product form
                )));
  }

// add new product to the database/stock
  void addProduct(String barcode, String name, String brand, String category,
      String price, String quantity, String size, String Location) {
    var intBarcode = int.tryParse(barcode);

// insert into database
    databaseRef.child("Products").child("$intBarcode").set({
      'Name': name,
      'Brand': brand,
      'Category': category,
      'Price': double.tryParse(price),
      'Quantity': int.tryParse(quantity),
      'Size': size,
      'Location': Location,
    });
    pbarcodeController.clear();
    pNameController.clear();
    pBrandController.clear();
    pCategoryController.clear();
    pPriceController.clear();
    pQuantityController.clear();
    pSizeController.clear();
    pLocController.clear();
  }
}

class scanProductBarcode extends StatefulWidget {
  const scanProductBarcode({Key? key}) : super(key: key);
  @override
  State<scanProductBarcode> createState() => _scanProductBarcodeState();
}

class _scanProductBarcodeState extends State<scanProductBarcode> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // scanner page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white, actions: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  iconSize: 44,
                  alignment: Alignment.topRight,
                  color: appColor,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProductsListAdmin();
                    }));
                  },
                  icon: Icon(Icons.keyboard_arrow_right)))
        ]),
        backgroundColor: Colors.white24,
        body: Column(children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
              flex: 1,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                        child: Text(
                            'قم بمسح الرمز الشريطي للمنتج لإضافته إلى المخزون',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17)))
                  ]))
        ]));
  }

  // the barcode scan area
  Widget _buildQrView(BuildContext context) {
    // check device's size and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation,
    // listen for Flutter SizeChanged notification and update controller
    return QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: appColor,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: scanArea),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p));
  }

  void _onQRViewCreated(QRViewController controller) {
    int check = 0;
    setState(() {
      this.controller = controller;
    });

//if the scanner has read the product's barcode number return to "add new prduct page" to complete the "add new product form"
    controller.scannedDataStream.listen((scanData) {
      check++;
      if (check == 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddNewProduct(scanData.code.toString())));
      }
    });
  }

  // Admin must allow the camera to scan by clicking on the scanner icon, then allow permission
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا يوجد سماح من الكاميرا')));
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
