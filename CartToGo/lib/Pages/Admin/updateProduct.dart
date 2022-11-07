import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:carttogo/main.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:carttogo/Pages/Admin/adminProductsList.dart';
import 'package:dropdown_search/dropdown_search.dart';

class UpdateProduct extends StatefulWidget {
  String SearchBarcode;
  int quantity = 0;
  double price;
  double priceAfterOffer;
  bool onOffer;
  UpdateProduct(this.SearchBarcode, this.quantity, this.price,
      this.priceAfterOffer, this.onOffer);

  @override
  State<UpdateProduct> createState() => UpdateProductState(
      SearchBarcode, quantity, price, priceAfterOffer, onOffer);
}

class UpdateProductState extends State<UpdateProduct> {
  String SearchBarcode;
  static int quantity = 0;
  static double price = 0;
  static double priceAfterOffer = 0;
  static bool onOffer = false;
  UpdateProductState(
      this.SearchBarcode, quantity, price, priceAfterOffer, onOffer);

  final _formKey = GlobalKey<FormState>();
  var quantityController = TextEditingController(text: quantity.toString());
  var priceController = TextEditingController(text: price.toString());
  var newPriceController =
      TextEditingController(text: priceAfterOffer.toString());
  bool isOffer = true;
  List<String> Locations = [
    'ممر 1',
    'ممر 2',
    'ممر 3',
    'ممر 4',
    'ممر 5',
    'ممر 6',
    'ممر 7',
    'ممر 8',
    'ممر 9',
    'ممر 10',
    'ممر 11',
    'ممر 12'
  ];
  String? selectedLocation; // to save the value of chosen location

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: appColor,
          ),
          backgroundColor: Colors.white,
          title: const Text("بيانات المنتج الجديدة",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    key: _formKey,
                    child: Column(children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 40),

                            // new product's price
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'(^\d*\.?\d*)'))
                                  ], // Only numbers can be entered
                                  controller: priceController,
                                  decoration: const InputDecoration(
                                    labelText: "السعر",
                                    labelStyle: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                    hintText: "أدخل سعر المنتج ",
                                    hintStyle: TextStyle(fontSize: 14),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
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
                            const SizedBox(height: 15),

                            // new product's quantity
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ], // Only numbers can be entered
                                  controller: quantityController,
                                  decoration: const InputDecoration(
                                    labelText: "الكمية",
                                    labelStyle: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                    hintText: "أدخل كمية المنتج ",
                                    hintStyle: TextStyle(fontSize: 14),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
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
                                      return ' كمية المنتج يجب ان لا تحتوي على احرف';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {}),
                            ),
                            SizedBox(height: 15),

                            // new product's location
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: DropdownSearch<String>(
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  showSelectedItems: true,
                                ),
                                //  list of products' location
                                items: Locations,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      borderSide:
                                          BorderSide(width: 2, color: appColor),
                                    ),
                                    labelText: 'الموقع',
                                    labelStyle: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ),
                                // After selecting the location ,it will
                                // change button value to selected location
                                onChanged: (String? newLocation) {
                                  setState(() {
                                    selectedLocation = newLocation!;
                                  });
                                },
                                validator: (value) => value == null
                                    ? 'الرجاء اختيار الموقع'
                                    : null,
                              ),
                            ),
                            SizedBox(height: 15),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Switch(
                                    activeTrackColor:
                                        Color.fromARGB(255, 64, 209, 98),
                                    activeColor:
                                        Color.fromARGB(255, 51, 161, 76),
                                    inactiveThumbColor:
                                        Color.fromARGB(255, 169, 44, 35),
                                    inactiveTrackColor: Colors.red,
                                    value: isOffer,
                                    onChanged: (value) {
                                      setState(() {
                                        isOffer = value;
                                        print(isOffer.toString());
                                      });
                                    }),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.45),
                                Text(
                                  "هل المنتج له عرض؟",
                                  style: TextStyle(
                                      fontFamily: 'CartToGo',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                          ]),

                      // will shown only if the product is on offer
                      // price after offer
                      Column(
                        children: [
                          Visibility(
                            visible: isOffer,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'(^\d*\.?\d*)'))
                                  ],
                                  // Only numbers can be entered
                                  controller: newPriceController,
                                  decoration: const InputDecoration(
                                    labelText: "السعر بعد العرض",
                                    labelStyle: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                    hintText: "أدخل سعر المنتج",
                                    hintStyle: TextStyle(fontSize: 14),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: InkWell(
                              highlightColor: Colors.grey[200],
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (quantityController.text.isNotEmpty &&
                                      priceController.text.isNotEmpty &&
                                      selectedLocation!.isNotEmpty) {
                                    updateProductInfo(
                                        quantityController,
                                        priceController,
                                        selectedLocation.toString(),
                                        newPriceController,
                                        isOffer);
                                  }

                                  Navigator.of(context).pop();
                                }
                              },
                              child: Center(
                                  child: Text("تحديث",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: appColor,
                                        fontWeight: FontWeight.bold,
                                      ))))),
                      Divider(
                        height: 1,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: InkWell(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0),
                              ),
                              highlightColor: Colors.grey[200],
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Center(
                                  child: Text("إلغاء",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      )))))
                    ])))));
  }

// add the new product's info to the database
  updateProductInfo(quantityController, priceController, selectedLocation,
      newPriceControlle, state) async {
    //selectedLocatio in arg
    DatabaseReference ref1 =
        FirebaseDatabase.instance.ref("Products/$SearchBarcode");
    await ref1.update({
      "Quantity": int.tryParse(quantityController.text),
      "Price": double.tryParse(priceController.text),
      "Location": selectedLocation,
      "Offer": state,
      if (state) "PriceAfterOffer": double.tryParse(newPriceController.text)
    });
  }
}
