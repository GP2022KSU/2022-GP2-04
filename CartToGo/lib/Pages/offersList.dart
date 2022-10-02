import 'package:carttogo/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carttogo/Pages/welcomePage.dart';
import 'package:flutter/rendering.dart';

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
  var k;

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
      body: FirebaseAnimatedList(
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

          var map;
          bool isOffer = false;

          try {
            var map = snapshot.value as Map<dynamic, dynamic>;
            isOffer = map['Offer'];
          } on Exception {}

          //عرض المنتج اللي عليه عرض
          // if كأنه
          // isOffer == false?
          //     Center(
          //         child: Text(
          //           "لا توجد عروض",
          //           style: TextStyle(
          //               color: Colors.black,
          //               fontWeight: FontWeight.bold,
          //               fontFamily: 'CartToGo',
          //               fontSize: 18),
          //         )) : else كأنه
          //     عرض ليست العروض

          //box design
          //يعرض بس اللي عليهم عروض
          if (isOffer) {
            return GestureDetector(
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

                      // product information arrangement in the container
                      title: Text(
                        l[6], // name of the product
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CartToGo',
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.right,
                      ),

                      // offer icon
                      leading: Icon(
                        Icons.discount,
                        color: Colors.red,
                      ),

                      //price for the products
                      trailing: Column(
                        children: [
                          Text(
                            "\t" +
                                "السعر:" +
                                l[8] + // price before
                                " ريال",
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
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
                                l[0] + // price after offer
                                " ريال",
                            textAlign: TextAlign.right,
                            style: TextStyle(
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
}
