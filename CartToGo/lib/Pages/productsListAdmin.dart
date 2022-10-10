import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:carttogo/main.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carttogo/Pages/welcomePage.dart';
import 'package:carttogo/Pages/addNewProduct.dart';
import 'package:flutter/rendering.dart';
import 'adminSearch.dart';
import 'package:carttogo/Users/user.dart' as user;
import 'package:flutter/cupertino.dart';

class ProductsListAdmin extends StatefulWidget {
  @override
  State<ProductsListAdmin> createState() => ProductsListAdmins();
}

class ProductsListAdmins extends State<ProductsListAdmin> {
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
  String? selectedLocation; // to save the value of chosen location
  bool isOffer = false;
  static bool ShowOfferPrice = false;
  bool isScrolled = false;
  final fb = FirebaseDatabase.instance;
  final _formKey = GlobalKey<FormState>();

  var l;
  var g;
  var k;

  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child('Products');

    return Scaffold(
      // add new product button to navigate the admin to add new product form
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddNewProduct(" ");
          }));
        },
        isExtended: isScrolled,
        icon: Icon(Icons.add),
        label: Text(
          "إضافة منتج جديد",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'CartToGo',
            fontSize: 17,
          ),
        ),
        backgroundColor: appColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      ),
      // end of add new prodcut button

      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white24,
        centerTitle: true,
        elevation: 0,
        title: const Text("المنتجات",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),

        // search icon to press when searching for a product
        leading: IconButton(
          onPressed: () async {
            final result = await showSearch<String>(
              context: context,
              delegate: AdminSearch(user.getBarcode()),
            );

          },
          icon: Icon(Icons.search_outlined),
          color: appColor,
        ),

        // logout button
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(3),
                    textStyle: MaterialStateProperty.all(const TextStyle(
                        fontSize: 14,
                        fontFamily: 'CartToGo',
                        fontWeight: FontWeight.bold)),
                    fixedSize: MaterialStateProperty.all(const Size(70, 10)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    foregroundColor: MaterialStateProperty.all(Colors.white)),
                onPressed: () async {
                  _showMyDialog();
                },
                child: const Text('خروج')),
          ),
        ],
        // end of logout button
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            setState(() {
              isScrolled = true;
            });
          } else if (notification.direction == ScrollDirection.reverse) {
            setState(() {
              isScrolled = false;
            });
          }
          return true;
        },
        child: FirebaseAnimatedList(
          padding: const EdgeInsets.all(8.0),
          query: ref,
          shrinkWrap: true,
          itemBuilder: (context, snapshot, animation, index) {
            var v = snapshot.value.toString();
            g = v.replaceAll(
                RegExp(
                    "{|}|Name: |Price: |Size: |Quantity: |Category: |Brand: |Barcode: |Location: |Offer: |PriceAfterOffer: "),
                "");
            g.trim();
            l = g.split(',');

            return GestureDetector(

                // products list
                child: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: Color.fromARGB(229, 229, 227, 227),

                    // delete product option
                    trailing: IconButton(
                      tooltip: "حذف المنتج",
                      icon: Icon(
                        Icons.delete,
                        color: Color.fromARGB(255, 255, 0, 0),
                      ),
                      onPressed: () {
                        var EE = ref.child(snapshot.key!);
                        _DeleteOrNot(EE);
                      },
                    ),

                    // update product option
                    leading: IconButton(
                      tooltip: "تعديل المنتج",
                      icon: Icon(
                        Icons.edit,
                        color: Color.fromARGB(255, 94, 90, 90),
                      ),
                      onPressed: () async {
                        setState(() {
                          k = snapshot.key;
                          var v = snapshot.value.toString();
                        });
                        g = v.replaceAll(
                            RegExp(
                                "{|}|Name: |Brand: |Category: |Price: |Size: |Quantity: |Barcode: |Location: |PriceAfterOffer: |SearchBarcode: |Offer:"),
                            "");
                        g.trim();
                        l = g.split(',');

                        var map;
                        bool isOffer = false;

                        try {
                          var map = snapshot.value as Map<dynamic, dynamic>;
                          if (map['Offer'] == true) isOffer = true;
                        } on Exception {}

                        var QUANTITY = l[1]; //Quantity on IOS is 1
                        var PRICE = l[9]; //Price on IOS is 8
                        var LOCATION = l[6];
                        var ONOFFER = l[8]; //offer on IOS is 7
                        var NEWPRICE = l[0]; //PriceAfterOffer on IOS is 0
                        _UpdateOrNot(QUANTITY, PRICE, LOCATION, ONOFFER,
                            NEWPRICE, isOffer);
                      },
                    ),

                    // product information arrangement in the container
                    title: Text(
                      l[7],
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'CartToGo',
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    subtitle: Text(
                      "\t" +
                          "العلامة التجارية: " +
                          l[10] +
                          "\n"
                              "\t" +
                          "الفئه: " +
                          l[5] +
                          "\n" +
                          "\t" +
                          "الكمية:" +
                          l[1] +
                          "\n" +
                          "\t" +
                          "الحجم:" +
                          l[4] +
                          "\n" +
                          "\t" +
                          "الموقع:" +
                          l[6] +
                          "\n" +
                          "\t" +
                          "السعر:" +
                          l[9] +
                          " ريال",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'CartToGo',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ));
          },
        ),
      ),
    );
  }

  //logout dialog, to ensure that the admin want to log out or not
  void _showMyDialog() async {
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
                    Text("هل تريد تسجيل الخروج؟",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        )),
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
                              await FirebaseAuth.instance.signOut();
                              print(
                                  "UID: ${FirebaseAuth.instance.currentUser?.uid}");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WelcomePage()));
                            },
                            child: Center(
                                child: Text("خروج",
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
                                child: Text("إلغاء",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    )))))
                  ])));
        });
  }

  // dialog to ensure the admin wants to delete a product or not
  void _DeleteOrNot(var delete) async {
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
                              await delete.remove();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductsListAdmin()));
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
                                      fontWeight: FontWeight.w400,
                                    )))))
                  ])));
        });
  }

// dialog to enter the new product info
  void _UpdateOrNot(
      QUANTITY, PRICE, LOCATION, ONOFFER, NEWPRICE, isOffer) async {
    // controllers to take/save the new product's information
    var quantityController = TextEditingController(text: QUANTITY);
    var priceController = TextEditingController(text: PRICE);
    var newPriceController = TextEditingController(text: NEWPRICE);

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
                      padding: const EdgeInsets.all(8.0),
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
                                      setState(() {
                                        selectedLocation = newLocation!;
                                      });
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
                                                selectedLocation!.isNotEmpty) {
                                              updateProductInfo(
                                                  quantityController,
                                                  priceController,
                                                  selectedLocation.toString(),
                                                  newPriceController,
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
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return ProductsListAdmin();
                                          }));
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
  updateProductInfo(quantityController, priceController, selectedLocation,
      newPriceController, state) async {
    //selectedLocatio in arg
    DatabaseReference ref1 = FirebaseDatabase.instance.ref("Products/$k");
    await ref1.update({
      "Quantity": int.tryParse(quantityController.text),
      "Price": double.tryParse(priceController.text),
      "Location": selectedLocation,
      "Offer": state,
      "PriceAfterOffer": double.tryParse(newPriceController.text),
    });
  }

  void _showDialog(String pass) async {
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
                    Text(pass,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        )),
                    SizedBox(height: 20),
                    Divider(
                      height: 2,
                      color: Colors.black,
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
                                child: Text("موافق",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: appColor)))))
                  ])));
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
