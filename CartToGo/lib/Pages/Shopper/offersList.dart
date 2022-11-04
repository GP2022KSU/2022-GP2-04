import 'dart:convert';
import 'package:carttogo/Users/user.dart' as user;
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carttogo/Pages/welcomePage.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OffersList extends StatefulWidget {
  OffersList({Key? key}) : super(key: key);
  @override
  _OffersListState createState() => _OffersListState();
}

class _OffersListState extends State<OffersList> {
  List<String> Recommended = [];
  bool isOffer = false;
  final fb = FirebaseDatabase.instance;
  late bool _isLoading;
  int count = 0;
  void initState() {
    _isLoading = true;
    _SeeAPI();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      _SeeAPI();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child('Products');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white24,
        centerTitle: true,
        elevation: 0,
        title: const Text("العروض",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),

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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // if the shopper has previous purchases, and there are offers,
            // recommendations of the same product subcategory will appear
            FutureBuilder<List<String>>(
                future: _SeeAPI(),
                builder:
                    (BuildContext context, AsyncSnapshot<List<String>> asyn) {
                  if (asyn.data != null) {
                    print(asyn.data!.isEmpty);
                  }
                  if (asyn.data != null && asyn.data!.isNotEmpty) {
                    Recommended = asyn.data as List<String>;
                    return Column(
                      children: [
                        const Divider(
                          indent: 40,
                          endIndent: 40,
                          height: 1,
                          color: Color.fromARGB(255, 3, 0, 188),
                        ),
                        const Text(
                          "العروض على المنتجات التي اشتريتها مسبقا",
                          style: TextStyle(
                            color: Color.fromARGB(255, 3, 0, 188),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CartToGo',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Divider(
                          indent: 40,
                          endIndent: 40,
                          height: 1,
                          color: Color.fromARGB(255, 3, 0, 188),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: FirebaseAnimatedList(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.all(8.0),
                            query: ref,
                            shrinkWrap: true,
                            itemBuilder: (context, snapshot, animation, index) {
                              bool Noimg = true;
                              bool SameBarcode = false;
                              var map;
                              bool isOffer = false;
                              String Name = "";
                              String Brand = "";
                              String imgUrl = '';
                              double price = 0.0;
                              double offerprice = 0.0;

                              try {
                                var map =
                                    snapshot.value as Map<dynamic, dynamic>;
                                if (map['Offer'] == true) isOffer = true;
                                Name = map['Name'];
                                Brand = map['Brand'];
                                if (map['ImgUrl'] == "") {
                                  Noimg = true;
                                } else {
                                  Noimg = false;
                                  imgUrl = map['ImgUrl'];
                                }

                                price = double.parse(map['Price'].toString());
                                offerprice = double.parse(
                                    map['PriceAfterOffer'].toString());
                                for (int i = 0; i < Recommended.length; i++) {
                                  if (map['SearchBarcode'] == Recommended[i]) {
                                    SameBarcode = true;
                                  }
                                }
                              } on Exception {}

                              if (isOffer & SameBarcode) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Card(
                                      shadowColor: Color.fromARGB(255, 8, 8, 8),
                                      elevation: 1,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Column(
                                          children: [
                                            Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.13,
                                                alignment: Alignment.center,
                                                child: Image.network(
                                                  imgUrl,
                                                  fit: BoxFit.contain,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                )),
                                            Text(
                                              Name +
                                                  " " +
                                                  Brand, // name of the product
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'CartToGo',
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                            Text(
                                              "\t" +
                                                  "السعر:" +
                                                  price
                                                      .toString() + // price before
                                                  " ريال",
                                              style: const TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Color.fromARGB(
                                                    255, 110, 110, 110),
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'CartToGo',
                                                fontSize: 12,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                            Text(
                                              "\t" +
                                                  "السعر بعد العرض: " +
                                                  offerprice
                                                      .toString() + // price after offer
                                                  " ريال",
                                              textAlign: TextAlign.right,
                                              style: const TextStyle(
                                                // decoration: TextDecoration.lineThrough,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'CartToGo',
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              }
                              return Container();
                            },
                          ),

                          //General offers for all shoppers
                        ),
                        const Divider(
                          indent: 40,
                          endIndent: 40,
                          height: 1,
                          color: Color.fromARGB(255, 3, 0, 188),
                        ),
                        const Text(
                          "العروض",
                          style: TextStyle(
                            color: Color.fromARGB(255, 3, 0, 188),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CartToGo',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Divider(
                          indent: 40,
                          endIndent: 40,
                          height: 1,
                          color: Color.fromARGB(255, 3, 0, 188),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.49,
                          child: FirebaseAnimatedList(
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.all(8.0),
                            query: ref,
                            shrinkWrap: true,
                            itemBuilder: (context, snapshot, animation, index) {
                              var map;
                              bool Noimg = true;
                              String imgUrl = '';
                              bool isOffer = false;
                              String Name = "";
                              String Brand = "";
                              double price = 0.0;
                              double offerprice = 0.0;
                              try {
                                var map =
                                    snapshot.value as Map<dynamic, dynamic>;
                                if (map['Offer'] == true) isOffer = true;
                                Name = map['Name'];
                                Brand = map['Brand'];
                                if (map['ImgUrl'] == "") {
                                  Noimg = true;
                                } else {
                                  Noimg = false;
                                  imgUrl = map['ImgUrl'];
                                }
                                price = double.parse(map['Price'].toString());
                                offerprice = double.parse(
                                    map['PriceAfterOffer'].toString());
                              } on Exception {}

                              if (isOffer) {
                                return Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                            color: Colors.white,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        //tileColor:
                                        //    Color.fromARGB(150, 255, 254, 254),

                                        // product information arrangement in the container
                                        title: Text(
                                          Name +
                                              " " +
                                              Brand, // name of the product
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'CartToGo',
                                            fontSize: 15,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),

                                        // offer icon
                                        leading: Noimg == true
                                            ? const Icon(
                                                Icons.discount,
                                                color: Colors.red,
                                              )
                                            : Image.network(
                                                imgUrl,
                                                fit: BoxFit.contain,
                                                width: 50,
                                                height: 60,
                                              ),

                                        //price for the products
                                        trailing: Column(
                                          children: [
                                            Text(
                                              "\t" +
                                                  "السعر:" +
                                                  price
                                                      .toString() + // price before
                                                  " ريال",
                                              style: const TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'CartToGo',
                                                fontSize: 12,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                            Text(
                                              "\t" +
                                                  "السعر بعد العرض:" +
                                                  offerprice
                                                      .toString() + // price after offer
                                                  " ريال",
                                              textAlign: TextAlign.right,
                                              style: const TextStyle(
                                                // decoration: TextDecoration.lineThrough,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'CartToGo',
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return Container();
                            },
                          ),
                        ),
                      ],
                    );
                  } else if (asyn.connectionState == ConnectionState.waiting &&
                      _isLoading) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: const SpinKitWave(
                          color: Color.fromARGB(255, 35, 61, 255),
                        ));
                  } else if (asyn.data!.isEmpty) {
                    count++;
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: FirebaseAnimatedList(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.all(8.0),
                        query: ref,
                        shrinkWrap: true,
                        itemBuilder: (context, snapshot, animation, index) {
                          var map;
                          bool Noimg = true;
                          String imgUrl = '';
                          bool isOffer = false;
                          String Name = "";
                          String Brand = "";
                          double price = 0.0;
                          double offerprice = 0.0;
                          try {
                            var map = snapshot.value as Map<dynamic, dynamic>;
                            if (map['Offer'] == true) isOffer = true;
                            Name = map['Name'];
                            Brand = map['Brand'];
                            if (map['ImgUrl'] == "") {
                              Noimg = true;
                            } else {
                              Noimg = false;
                              imgUrl = map['ImgUrl'];
                            }
                            price = double.parse(map['Price'].toString());
                            offerprice =
                                double.parse(map['PriceAfterOffer'].toString());
                          } on Exception {}

                          if (isOffer) {
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    //tileColor:
                                    //    Color.fromARGB(150, 255, 254, 254),

                                    // product information arrangement in the container
                                    title: Text(
                                      Name + " " + Brand, // name of the product
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'CartToGo',
                                        fontSize: 15,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),

                                    // offer icon
                                    leading: Noimg == true
                                        ? const Icon(
                                            Icons.discount,
                                            color: Colors.red,
                                          )
                                        : Image.network(
                                            imgUrl,
                                            fit: BoxFit.contain,
                                            width: 50,
                                            height: 60,
                                          ),

                                    //price for the products
                                    trailing: Column(
                                      children: [
                                        Text(
                                          "\t" +
                                              "السعر:" +
                                              price.toString() + // price before
                                              " ريال",
                                          style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'CartToGo',
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                        Text(
                                          "\t" +
                                              "السعر بعد العرض:" +
                                              offerprice
                                                  .toString() + // price after offer
                                              " ريال",
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                            // decoration: TextDecoration.lineThrough,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'CartToGo',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    );
                  }
                  return Container();
                  //else if (countOffer <= 0) {
                  //   return Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       const SizedBox(
                  //         height: 50,
                  //       ),
                  //       Center(
                  //         child: Container(
                  //           width: MediaQuery.of(context).size.width * 0.20,
                  //           height: MediaQuery.of(context).size.height * 0.1,
                  //           decoration: const BoxDecoration(
                  //             image: DecorationImage(
                  //                 image: AssetImage('assets/images/invoice.png'),
                  //                 fit: BoxFit.fitWidth),
                  //           ),
                  //         ),
                  //       ),
                  //       const SizedBox(
                  //         height: 20,
                  //       ),
                  //       Center(
                  //           child: Container(
                  //               child: Transform.rotate(
                  //         angle: -1.2492672422141295e-13,
                  //         child: const Text(
                  //           'لا يوجد فواتير سابقة ',
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(
                  //               color: Color.fromARGB(219, 100, 98, 98),
                  //               fontFamily: 'CartToGo',
                  //               fontSize: 26,
                  //               fontWeight: FontWeight.w800,
                  //               height: 1),
                  //         ),
                  //       ))),
                  //     ],
                  //   );
                  // }
                }),
          ],
        ),
      ),
    );
  }

  Future<List<String>> _SeeAPI() async {
    //run python file
    final url = 'http://192.168.0.211:5000/name'; //local python API
    var purchasehis = "";
    final response = await http.post(Uri.parse(url),
        body: json.encode(user.getPurchaseHistory()));
    final response1 = await http.get(Uri.parse(url));

    //converting the fetched data from json to key value pair that can be displayed on the screen
    // print(response.body);
    // print(response1.body);
    List<String> RecomProductsBarcode =
        user.getRecomProducts(response1.body.toString());
    return RecomProductsBarcode;
  }

  //logout dialog, to ensure that the shopper want to log out or not
  void _showMyDialog() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
              textDirection: TextDirection.rtl,
              child: Dialog(
                  elevation: 0,
                  backgroundColor: const Color(0xffffffff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(height: 15),
                    const Text("هل تريد تسجيل الخروج؟",
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 15),
                    const Divider(
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const WelcomePage()));
                            },
                            child: const Center(
                                child: const Text("خروج",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Color(0xFFFE4A49),
                                      fontWeight: FontWeight.bold,
                                    ))))),
                    const Divider(
                      height: 1,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: InkWell(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: const Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0),
                            ),
                            highlightColor: Colors.grey[200],
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Center(
                                child: Text("إلغاء",
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    )))))
                  ])));
        });
  }
}
