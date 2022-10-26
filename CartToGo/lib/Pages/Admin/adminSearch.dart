import 'package:carttogo/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'adminProductsList.dart';
import 'package:flutter/cupertino.dart';

class AdminSearch extends SearchDelegate<String> {
  final List<String> barcodes;
  var splitted;
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
  bool isOffer = false;
  static bool ShowOfferPrice = false;

  late String selectedLocation; // to save the value of the new location
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

  // to clear the search bar
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

// when the admin chooses a product by clicking on it or tapping enter, the result will be centered on the screen
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
              onTap: () {
                query = barcodes[index];
              },
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

  // delete a product from the database/stock choice
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
    // controllers to take/save the new product's information
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
                                        alignment: Alignment.topRight,
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

                                // Ask Admin for Product Offers & Adding, Deleting it
                                SwitchScreen(),
                                SizedBox(height: 15),

                                // will shown only if the product have an offer
                                //if (isOffer || ShowOfferPrice)

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
                                            bool state = SwitchClass.Offerstate;
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
                                                  barcode,
                                                  state);
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

// add the new product's info to the database/stock
  updateProductInfo(quantityController, priceController, selectedLocatio,
      newPriceController, String barcode, state) async {
    DatabaseReference ref1 = FirebaseDatabase.instance.ref("Products/$barcode");
    await ref1.update({
      "Quantity": int.tryParse(quantityController.text),
      "Price": double.tryParse(priceController.text),
      "Location": selectedLocation,
      "Offer": state,
      "PriceAfterOffer": double.tryParse(newPriceController.text),
    });
  }
}

class SwitchScreen extends StatefulWidget {
  // This class for asking the admin fot offer
  @override
  SwitchClass createState() => new SwitchClass();
}

class SwitchClass extends State {
  static bool Offerstate = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Column(
      children: [
        Container(
          child: Row(
            children: [
              Divider(
                height: 1,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: Row(
                  children: [
                    Text(
                      "لدى المنتج عرض  ؟",
                      style: TextStyle(
                          fontFamily: 'CartToGo',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Offerstate == true ? "   نعم   " : "   لا   ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CartToGo',
                          fontSize: 14,
                          color: Offerstate == true
                              ? CupertinoColors.activeGreen
                              : CupertinoColors.destructiveRed),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: CupertinoSwitch(
                  value: Offerstate,
                  onChanged: (value) {
                    //Offerstate = value;
                    setState(() {
                      ProductsListAdmins.ShowOfferPrice = value;
                      print(ProductsListAdmins.ShowOfferPrice);
                      Offerstate = value;
                    });
                  },
                ),
              ),
              Divider(
                height: 1,
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
