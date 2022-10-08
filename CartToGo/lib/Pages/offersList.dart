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
  final fb = FirebaseDatabase.instance;

  bool isOffer = false;
  var l;
  var g;
  late bool _isLoading;
  List<String> Recommended = [];
  void initState() {
    _isLoading = true;
    _SeeAPI();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
      body: Column(
        children: [
          FutureBuilder<List<String>>(
              future: _SeeAPI(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> asyn) {
                if (asyn.data != null) {
                  Recommended = asyn.data as List<String>;
                  return Column(
                    children: [
                      Text(
                        "العروض على المنتجات التي اشتريتها مسبقا",
                        style: TextStyle(
                          color: Color.fromARGB(255, 3, 0, 188),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CartToGo',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: FirebaseAnimatedList(
                          padding: const EdgeInsets.all(8.0),
                          query: ref,
                          shrinkWrap: true,
                          itemBuilder: (context, snapshot, animation, index) {
                            bool SameBarcode = false;
                            var map;
                            bool isOffer = false;
                            String Name = "";
                            double price = 0.0;
                            double offerprice = 0.0;
                            try {
                              var map = snapshot.value as Map<dynamic, dynamic>;
                              if (map['Offer'] == true) isOffer = true;
                              Name = map['Name'];
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
                              return GestureDetector(
                                child: Directionality(
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
                                        //tileColor: const Color.fromARGB(
                                        //    229, 229, 227, 227),

                                        // product information arrangement in the container
                                        title: Text(
                                          Name, // name of the product
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'CartToGo',
                                            fontSize: 17,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),

                                        // offer icon
                                        leading: const Icon(
                                          Icons.discount,
                                          color: Colors.red,
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
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                      Text(
                        "العروض",
                        style: TextStyle(
                          color: Color.fromARGB(255, 3, 0, 188),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CartToGo',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.44,
                        child: FirebaseAnimatedList(
                          padding: const EdgeInsets.all(8.0),
                          query: ref,
                          shrinkWrap: true,
                          itemBuilder: (context, snapshot, animation, index) {
                            var map;
                            bool isOffer = false;
                            String Name = "";
                            double price = 0.0;
                            double offerprice = 0.0;
                            try {
                              var map = snapshot.value as Map<dynamic, dynamic>;
                              if (map['Offer'] == true) isOffer = true;
                              Name = map['Name'];
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
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      //tileColor:
                                      //    Color.fromARGB(150, 255, 254, 254),

                                      // product information arrangement in the container
                                      title: Text(
                                        Name, // name of the product
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'CartToGo',
                                          fontSize: 17,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),

                                      // offer icon
                                      leading: const Icon(
                                        Icons.discount,
                                        color: Colors.red,
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
                } else if (asyn.connectionState == ConnectionState.waiting) {
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: SpinKitWave(
                        color: Color.fromARGB(255, 35, 61, 255),
                      ));
                }
                return Container();
              }),
        ],
      ),
    );
  }

  Future<List<String>> _SeeAPI() async {
    //run python file
    final url = 'http://172.20.10.3:5000/name'; //local python API
    var purchasehis = "";
    final response = await http.post(Uri.parse(url),
        body: json.encode(user.getPurchaseHistory()));
    final response1 = await http.get(Uri.parse(url));

    //converting the fetched data from json to key value pair that can be displayed on the screen
    print(response.body);
    print(response1.body);
    List<String> RecomProductsBarcode =
        user.getRecomProducts(response1.body.toString());
    return RecomProductsBarcode;
    //final decoded = await json.decode(response1.body) as Map<String, dynamic>;
    //print(decoded);
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
                              print(
                                  "UID: ${FirebaseAuth.instance.currentUser?.uid}");
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
