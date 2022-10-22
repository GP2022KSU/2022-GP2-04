import 'package:carttogo/Pages/welcomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carttogo/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class AdminOffers extends StatefulWidget {
  AdminOffers({Key? key}) : super(key: key);
  @override
  _AdminOffersState createState() => _AdminOffersState();
}

class _AdminOffersState extends State<AdminOffers> {
  final fb = FirebaseDatabase.instance;
  bool isOffer = false;
  var l;
  var g;
  late bool _isLoading;
  void initState() {
    _isLoading = true;
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: appColor),
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
      body: Column(children: [
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
                            width: 2,
                            color: appColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),

                        // product information arrangement in the container
                        title: Text(
                          Name + " " + Brand,
                          // name of the product
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CartToGo',
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.right,
                        ),

                        // offer icon
                        leading: Noimg == true
                            ? const Icon(
                                Icons.discount,
                                color: Colors.red,
                              )
                            : Image.network(imgUrl),

                        //price for the products
                        trailing: Column(
                          children: [
                            // Text(
                            //   "\t" +
                            //       "السعر:" +
                            //       price.toString() + // price before
                            //       " ريال",
                            //   style: const TextStyle(
                            //     decoration: TextDecoration.lineThrough,
                            //     color: Colors.black,
                            //     fontWeight: FontWeight.bold,
                            //     fontFamily: 'CartToGo',
                            //     fontSize: 12,
                            //   ),
                            //   textAlign: TextAlign.right,
                            // ),
                            // Text(
                            //   "\t" +
                            //       "السعر بعد العرض:" +
                            //       offerprice.toString() + // price after offer
                            //       " ريال",
                            //   textAlign: TextAlign.right,
                            //   style: const TextStyle(
                            //     // decoration: TextDecoration.lineThrough,
                            //     color: Colors.black,
                            //     fontWeight: FontWeight.bold,
                            //     fontFamily: 'CartToGo',
                            //     fontSize: 12,
                            //   ),
                            // ),
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
      ]),
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
