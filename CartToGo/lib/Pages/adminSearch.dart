import 'package:carttogo/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'productsListAdmin.dart';

class AdminSearch extends SearchDelegate<String> {
  final List<String> barcodes;
  var splitted;
  List<String> Locations = [
    'ممر 12',
    'ممر 11',
    'ممر 10',
    'ممر 9',
    'ممر 8',
    'ممر 7',
    'ممر 6',
    'ممر 5',
    'ممر 4',
    'ممر 3',
    'ممر 2',
    'ممر 1'
  ];
  late String selectedLocation;
  final _formKey = GlobalKey<FormState>();

  final fb = FirebaseDatabase.instance;
  AdminSearch(this.barcodes)
      : super(
          searchFieldLabel: "  ابحث عن منتج لحذفه أو تعديله  ",
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

// to view the list without a keyboard
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(
            Icons.arrow_forward_ios_outlined,
            color: appColor,
          ),
          onPressed: () {
            close(context, "");
          }),
    ];
  }

  // to delete what in the search bar
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.cancel,
        color: appColor,
      ),
      onPressed: () {
        query = '';
      },
    );
  }

// when the admin chooses a product, the result will be centered on the screen
  @override
  Widget buildResults(BuildContext context) {
    return Center(
        child: Text(
      query,
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'CartToGo',
          fontSize: 18),
    ));
  }

// suggestions for products when searching for a product
  @override
  Widget buildSuggestions(BuildContext context) {
    final Suggestions = query.isEmpty
        ? barcodes
        : barcodes.where((p) => p.startsWith(query)).toList();
    return Suggestions.isEmpty && query.isNotEmpty
        ? Center(
            child: Text(
            "لا توجد منتجات بهذا الرمز الشريطي",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'CartToGo',
                fontSize: 18),
          ))
        : ListView.builder(
            itemCount: Suggestions.length,
            itemBuilder: (BuildContext context, int index) => ListTile(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              title: Row(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      tooltip: "تعديل المنتج",
                      icon: Icon(
                        Icons.edit,
                        color: Color.fromARGB(255, 94, 90, 90),
                      ),
                      onPressed: () async {
                        var splitted =
                            Suggestions.elementAt(index).split(" | ");
                        DatabaseReference ref = FirebaseDatabase.instance
                            .ref("Products/${splitted[0].toString()}");

                        DatabaseEvent quan = await ref.child("Quantity").once();
                        DatabaseEvent price = await ref.child("Price").once();
                        DatabaseEvent location =
                            await ref.child("Location").once();
                        DatabaseEvent offer = await ref.child("Offer").once();
                        DatabaseEvent nprice =
                            await ref.child("PriceAfterOffer").once();

                        var QUANTITY =
                            int.parse(quan.snapshot.value.toString());
                        var PRICE =
                            double.parse(price.snapshot.value.toString());
                        var LOCATION = location.snapshot.value.toString();
                        var OFFER = offer.snapshot.value.toString();
                        var NEWPRICE =
                            double.parse(nprice.snapshot.value.toString());
                        _UpdateOrNot(QUANTITY, PRICE, LOCATION, OFFER, NEWPRICE,
                            context, splitted[0].toString());
                      },
                    ),
                    IconButton(
                      tooltip: "حذف المنتج",
                      icon: Icon(
                        Icons.delete,
                        color: Color.fromARGB(255, 255, 0, 0),
                      ),
                      onPressed: () {
                        var splitted =
                            Suggestions.elementAt(index).split(" | ");
                        print(splitted[0]);
                        _DeleteOrNot(splitted[0].toString(), context);
                        barcodes.removeAt(index); //عشان يشيل من اللست ما ضبط
                      },
                    ),

                    // make the typing numbers bold
                    RichText(
                        text: TextSpan(
                            text: Suggestions.elementAt(index)
                                .substring(0, query.length),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CartToGo',
                            ),
                            // products list
                            children: [
                          TextSpan(
                            text: Suggestions.elementAt(index)
                                .substring(query.length),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'CartToGo',
                            ),
                          )
                        ])),
                    SizedBox(
                      width: 10,
                    ),
                    Divider() // to arrange the products list
                  ]),
            ),
          );
  }

  void _DeleteOrNot(String barcode, BuildContext context) async {
    final ref = fb.ref().child('Products/$barcode');
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
              textDirection: TextDirection.rtl,
              child: Dialog(
                  elevation: 0,
                  backgroundColor: Color(0xffffffff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    SizedBox(height: 15),
                    Text(
                      "هل تريد حذف المنتج؟",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
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
                              await ref.remove();
                              Navigator.of(context).pop();
                            },
                            child: Center(
                                child: Text("نعم",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Color(0xFFFE4A49),
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
                                child: Text("لا",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    )))))
                  ])));
        });
  }

  void _UpdateOrNot(QUANTITY, PRICE, LOCATION, ONOFFER, NEWPRICE,
      BuildContext context, String barcode) async {
    // controller to edit function
    var quantityController = TextEditingController(text: QUANTITY.toString());
    var priceController = TextEditingController(text: PRICE.toString());
    var newPriceController = TextEditingController(text: NEWPRICE.toString());

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
              textDirection: TextDirection.rtl,
              child: Dialog(
                  elevation: 0,
                  backgroundColor: Color(0xffffffff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Form(
                          key: _formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text("بيانات المنتج الجديدة",
                                        style: TextStyle(
                                          fontSize: 19,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ))),
                                SizedBox(height: 15),
                                Divider(
                                  height: 1.5,
                                ),
                                const SizedBox(height: 15),

                                // new product's price
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                      keyboardType:
                                          TextInputType.numberWithOptions(
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
                                          borderSide: BorderSide(
                                              width: 2, color: appColor),
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
                                          borderSide: BorderSide(
                                              width: 2, color: appColor),
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
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      labelText: "الموقع",
                                      labelStyle: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      hintStyle: TextStyle(fontSize: 14),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                        borderSide: BorderSide(
                                            width: 2, color: appColor),
                                      ),
                                    ),
                                    isExpanded: true,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: appColor,
                                    ),
                                    // Array list of locations
                                    items: Locations.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    validator: (value) => value == null
                                        ? 'الرجاء اختيار الموقع'
                                        : null,
                                    // After selecting the location ,it will
                                    // change button value to selected location
                                    onChanged: (String? newLocation) {
                                      selectedLocation = newLocation!;
                                    },
                                  ),
                                ),
                                SizedBox(height: 15),

                                // price after offer
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'(^\d*\.?\d*)'))
                                      ], // Only numbers can be entered
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
                                          borderSide: BorderSide(
                                              width: 2, color: appColor),
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
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (quantityController
                                                    .text.isNotEmpty &&
                                                priceController
                                                    .text.isNotEmpty &&
                                                selectedLocation.isNotEmpty) {
                                              updateProductInfo(
                                                  quantityController,
                                                  priceController,
                                                  selectedLocation.toString(),
                                                  newPriceController,
                                                  barcode);
                                            }
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ProductsListAdmin();
                                            }));
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
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                )))))
                              ])))));
        });
  }

// add the new product's info to the database
  updateProductInfo(quantityController, priceController, selectedLocatio,
      newPriceController, String barcode) async {
    DatabaseReference ref1 = FirebaseDatabase.instance.ref("Products/$barcode");
    await ref1.update({
      "Quantity": int.tryParse(quantityController.text),
      "Price": double.tryParse(priceController.text),
      "Location": selectedLocation,
      //"Offer" :
      "PriceAfterOffer": double.tryParse(newPriceController.text),
    });
  }
}
