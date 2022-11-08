import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:carttogo/main.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carttogo/Pages/welcomePage.dart';
import 'package:carttogo/Pages/Admin/addNewProduct.dart';
import 'package:flutter/rendering.dart';
import 'adminSearch.dart';
import 'package:carttogo/Users/user.dart' as user;
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:carttogo/Pages/Admin/updateProduct.dart';

class ProductsListAdmin extends StatefulWidget {
  @override
  State<ProductsListAdmin> createState() => ProductsListAdmins();
}

class ProductsListAdmins extends State<ProductsListAdmin> {
  // For offer filter, to show/hide offers
  bool onOffer = false;
  void showOffers() {
    setState(() {
      onOffer = !onOffer;
    });
  }

  // Locations list for the dropdown menue
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
  bool isOffer = false;
  bool isScrolled = false;
  static bool ShowOfferPrice = false;
  final fb = FirebaseDatabase.instance;
  final _formKey = GlobalKey<FormState>();
  var l;
  var g;
  var k;
  late Timer _timer;

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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white24,
        centerTitle: true,
        elevation: 0,
        title: Row(children: <Widget>[
          IconButton(
            onPressed: () async {
              final result = await showSearch<String>(
                context: context,
                delegate: AdminSearch(await user.BringProducts()),
              );
            },
            icon: Icon(
              Icons.search_outlined,
            ),
            color: appColor,
          ),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.discount_outlined),
                color: appColor,
                onPressed: () {
                  showOffers();
                },
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Text("المنتجات        ",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          )
        ]),

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
            var map = snapshot.value as Map<dynamic, dynamic>;

            if (onOffer == false) {
              return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 100),
                  child: SlideAnimation(
                      verticalOffset: 0,
                      child: FadeInAnimation(
                          child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 2,
                                    color: Color.fromARGB(226, 201, 199, 199)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              tileColor: Color.fromARGB(228, 255, 255, 255),
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
                                  color: appColor,
                                ),
                                onPressed: () async {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    var map =
                                        snapshot.value as Map<dynamic, dynamic>;
                                    return UpdateProduct(
                                        map["SearchBarcode"].toString(),
                                        int.parse(map['Quantity'].toString()),
                                        double.parse(map['Price'].toString()),
                                        double.parse(
                                            map['PriceAfterOffer'].toString()),
                                        map['Offer'] == true ? true : false,
                                        map['Location'].toString());
                                  }));

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

                                  bool isOffer = false;
                                  try {
                                    if (map['Offer'] == "true") isOffer = true;
                                  } on Exception {}

                                  var QUANTITY = int.parse(map["Quantity"]
                                      .toString()); //Quantity on IOS is 1
                                  var PRICE = l[7]; //Price on IOS is 8
                                  var LOCATION = l[3];
                                  var ONOFFER = l[8]; //offer on IOS is 7
                                  var NEWPRICE =
                                      l[11]; //PriceAfterOffer on IOS is 0
                                },
                              ),

                              // product information arrangement in the container
                              title: Text(
                                l[2] + l[4],
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
                                    l[4] +
                                    "\n"
                                        "\t" +
                                    "الفئه: " +
                                    l[9] +
                                    "\n" +
                                    "\t" +
                                    "الكمية:" +
                                    l[10] +
                                    "\n" +
                                    "\t" +
                                    "الحجم:" +
                                    l[6] +
                                    "\n" +
                                    "\t" +
                                    "الموقع:" +
                                    l[3] +
                                    "\n" +
                                    "\t" +
                                    "السعر:" +
                                    l[7] +
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
                      ))));
            }

            // To show only products that are on offer
            if (map['Offer'] == true && onOffer) {
              return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 300),
                  child: SlideAnimation(
                      verticalOffset: 0,
                      child: FadeInAnimation(
                          child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 2, color: appColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              tileColor: Color.fromARGB(228, 255, 255, 255),

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
                                  color: appColor,
                                ),
                                onPressed: () async {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return UpdateProduct(
                                        map["SearchBarcode"].toString(),
                                        int.parse(map['Quantity'].toString()),
                                        double.parse(map['Price'].toString()),
                                        double.parse(
                                            map['PriceAfterOffer'].toString()),
                                        map['Offer'] == true ? true : false,
                                        map['Location'].toString());
                                  }));

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
                                  try {
                                    if (map['Offer'] == "true") isOffer = true;
                                  } on Exception {}

                                  var QUANTITY = l[10]; //Quantity on IOS is 1
                                  var PRICE = l[7]; //Price on IOS is 8
                                  var LOCATION = l[3];
                                  var ONOFFER = l[8]; //offer on IOS is 7
                                  var NEWPRICE =
                                      l[11]; //PriceAfterOffer on IOS is 0
                                  // _UpdateOrNot(QUANTITY, PRICE, LOCATION,
                                  //     ONOFFER, NEWPRICE, isOffer);
                                },
                              ),

                              // product information arrangement in the list
                              title: Text(
                                l[2] + l[4],
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
                                    l[4] +
                                    "\n"
                                        "\t" +
                                    "الفئه: " +
                                    l[9] +
                                    "\n" +
                                    "\t" +
                                    "الكمية:" +
                                    l[10] +
                                    "\n" +
                                    "\t" +
                                    "الحجم:" +
                                    l[6] +
                                    "\n" +
                                    "\t" +
                                    "الموقع:" +
                                    l[3] +
                                    "\n" +
                                    "\t" +
                                    "السعر:" +
                                    l[7] +
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
                      ))));
            }
            return Container();
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
