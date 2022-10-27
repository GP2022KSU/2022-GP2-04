import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carttogo/Users/user.dart' as user;
import 'package:carttogo/Pages/Shopper/InvoicePage.dart';
import 'package:carttogo/Pages/Shopper/Navigation.dart';

class Cardhistory extends StatefulWidget {
  @override
  CardhistoryState createState() => CardhistoryState();
}

final _fb = FirebaseDatabase.instance;

class CardhistoryState extends State<Cardhistory> {
  @override
  Widget build(BuildContext context) {
    return Card(
        shadowColor: const Color.fromARGB(66, 13, 13, 13),
        elevation: 10,
        color: const Color.fromARGB(255, 248, 245, 245),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.94,
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckCarts(),
            ],
          ),
        ));
  }

  Widget CheckCarts() {
    return FutureBuilder<int>(
        future: user.BringPaidCarts(),
        builder: (BuildContext context, AsyncSnapshot<int> asyn) {
          if (user.getPaidCarts() <= 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/invoice.png'),
                          fit: BoxFit.fitWidth),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                    child: Container(
                        child: Transform.rotate(
                  angle: -1.2492672422141295e-13 * (math.pi / 180),
                  child: const Text(
                    'لا يوجد فواتير سابقة ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromARGB(219, 100, 98, 98),
                        fontFamily: 'CartToGo',
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        height: 1),
                  ),
                ))),
              ],
            );
          } else {
            return InvoiceHistory();
          }
        });
  }

  Widget InvoiceHistory() {
    return Container(
        height: MediaQuery.of(context).size.height * 0.45,
        width: MediaQuery.of(context).size.width * 0.9,
        //padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: FirebaseAnimatedList(
              query: _fb
                  .ref()
                  .child(
                      "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts")
                  .limitToFirst(user.getPaidCarts()),
              duration: const Duration(milliseconds: 300),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                int numofItems = 0;
                final map = snapshot.value as Map<dynamic, dynamic>;
                String InvoiceNumber = snapshot.key.toString();
                double total = 0;
                int gainedPoints = 0;
                int usedPoints = 0;
                String datePlaced = "";
                List<String> ImagesofCart = [];
                bool NoPoints = false;
                String timeBought = "";
                map.forEach((key, value) {
                  if (value['Name'] != null) numofItems++;
                  //Iterate through each cart product image
                  if (value['ImgUrl'] != null) {
                    for (int i = 0; i < ImagesofCart.length; i++) {
                      // to check img duplicates
                      if (value['ImgUrl'] == ImagesofCart[i]) {
                        ImagesofCart.removeAt(i);
                      }
                    }
                    ImagesofCart.add(value['ImgUrl']);
                  }
                  if (key == "CartInfo") {
                    total = double.parse(value['Total'].toString());
                    gainedPoints = int.parse(value['GainedPoints'].toString());
                    usedPoints = int.parse(value['UsedPoints'].toString());
                    datePlaced = value['Date'].toString();
                    timeBought = value['Time'].toString();
                  }
                });
                if (gainedPoints > 0) NoPoints = true;

                if (map['NumOfProducts'] == null) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 200),
                    child: SlideAnimation(
                      verticalOffset: 0,
                      child: FadeInAnimation(
                        child: Column(
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: ListTile(
                                  onTap: () async {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             NaviState().hh()));
                                    showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(30),
                                                bottom: Radius.circular(30))),
                                        isScrollControlled: true,
                                        context: context,
                                        useRootNavigator: true,
                                        builder: ((context) {
                                          return SingleChildScrollView(
                                              child: invoice(
                                                  InvoiceNumber,
                                                  numofItems,
                                                  total,
                                                  datePlaced,
                                                  timeBought,
                                                  gainedPoints,
                                                  usedPoints));
                                        }));
                                  },
                                  style: ListTileStyle.drawer,
                                  subtitle: SingleChildScrollView(
                                    dragStartBehavior: DragStartBehavior.start,
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: ImagesofCart.map(
                                          (url) => CircleAvatar(
                                                radius: 17,
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 248, 245, 245),
                                                child: Image.network(url),
                                              )).toList(),
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      const Text(
                                        " تم شرائه : ",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'CartToGo',
                                        ),
                                        textAlign: TextAlign.right,
                                        textDirection: TextDirection.rtl,
                                      ),
                                      Text(
                                        datePlaced + " - " + timeBought,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color.fromARGB(
                                              255, 148, 148, 148),
                                          fontFamily: 'CartToGo',
                                        ),
                                        textAlign: TextAlign.right,
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ],
                                  ),
                                  trailing: Column(
                                    children: [
                                      Text(
                                        total.toString() + " ريال",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'CartToGo',
                                        ),
                                        textAlign: TextAlign.right,
                                        textDirection: TextDirection.rtl,
                                      ),
                                      Visibility(
                                        visible: NoPoints,
                                        child: Text(
                                          gainedPoints.toString() + " + ",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 75, 236, 43),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'CartToGo',
                                          ),
                                          textAlign: TextAlign.right,
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                      // Expanded(
                                      //   flex: 1,
                                      //   child: Text(
                                      //     usedPoints.toString() + " - ",
                                      //     style: const TextStyle(
                                      //       fontSize: 15,
                                      //       color: Color.fromARGB(255, 235, 36, 36),
                                      //       fontWeight: FontWeight.bold,
                                      //       fontFamily: 'CartToGo',
                                      //     ),
                                      //     textAlign: TextAlign.right,
                                      //     textDirection: TextDirection.rtl,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  leading: Text(
                                    InvoiceNumber + "#",
                                    textAlign: TextAlign.left,
                                    textDirection: TextDirection.ltr,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 35, 61, 255),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'CartToGo',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(thickness: 1),
                            //const SizedBox(height: 2)
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              }),
        ));
  }

  //Invoice page when an invoice is selected from list above
  Widget invoice(String CartID, int numofProd, double total, String date,
      String time, int gainedpoints, int usedpoints) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Center(
        child: Column(
          children: [
            const Divider(
              height: 20,
              thickness: 4,
              indent: 100,
              endIndent: 100,
              color: Color.fromARGB(255, 35, 61, 255),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                Image.asset(
                  'assets/images/CartInvoice.png',
                  fit: BoxFit.contain,
                  height: 80,
                  width: 80,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.37,
                ),
                Text(
                  CartID + "#",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 35, 61, 255),
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
                const Text(
                  "فاتورة رقم: ",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  const Text(
                    " التاريخ والوقت: ",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'CartToGo',
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                  Text(
                    date + " - " + time,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color.fromARGB(255, 148, 148, 148),
                      fontFamily: 'CartToGo',
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
            Text(
              "(" + numofProd.toString() + ") :عدد المنتجات",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.ltr,
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              //Brings the products using the cartID
              height: MediaQuery.of(context).size.height * 0.35,
              child: FirebaseAnimatedList(
                  query: _fb.ref().child(
                      "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/$CartID"),
                  duration: const Duration(milliseconds: 500),
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    String Brand = "";
                    String Name = "";
                    double Price = 0;
                    bool HaveOffer = false;
                    String imgURL = "";
                    var map = snapshot.value as Map<dynamic, dynamic>;

                    if (map['Paid'] == null) {
                      //count all products in cart excluding the cartinfo child
                      try {
                        imgURL = map['ImgUrl'];
                        Name = map['Name'];
                        HaveOffer = map['Offer'];
                        Brand = map['Brand'];
                        HaveOffer
                            ? Price =
                                double.parse(map['PriceAfterOffer'].toString())
                            : Price = double.parse(map['Price'].toString());
                        // ignore: empty_catches
                      } on Exception {}
                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: ListTile(
                          leading: Image.network(
                            imgURL,
                            fit: BoxFit.contain,
                            width: 50,
                            height: 50,
                          ),
                          title: Text(
                            Name + " " + Brand,
                          ),
                          trailing: Text(
                            Price.toString() + " ريال",
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      );
                    }
                    return Container(); //If cart is not found
                  }),
            ),
            usedpoints <=
                    0 //either shows the used points or not if it is equal to 0
                ? Container()
                : Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 242, 240, 240),
                      //border: Border.all(color: Colors.black),
                    ),
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: <Widget>[
                        const Text(
                          "  النقاط المستخدمة  ",
                          //textAlign: TextAlign.right,
                          //textDirection: TextDirection.ltr,
                          style: TextStyle(
                              color: Color.fromRGBO(32, 26, 37, 1),
                              fontSize: 20,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.w700,
                              height: 0.9),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.37,
                        ),
                        Text(
                          usedpoints.toString() + " - ",
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 235, 36, 36),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              //fontWeight: FontWeight.w700,
                              height: 0.9),
                        ),
                      ],
                    ),
                  ),
            usedpoints <= 0
                ? Container()
                : const SizedBox(
                    height: 10,
                  ),
            gainedpoints <=
                    0 //either shows the gained points or not if it is equal to 0
                ? Container()
                : Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 242, 240, 240),
                      //border: Border.all(color: Colors.black),
                    ),
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: <Widget>[
                        const Text(
                          "     النقاط المكتسبة  ",
                          //textAlign: TextAlign.right,
                          //textDirection: TextDirection.ltr,
                          style: TextStyle(
                              color: Color.fromRGBO(32, 26, 37, 1),
                              fontSize: 20,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.w700,
                              height: 0.9),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.37,
                        ),
                        Text(
                          gainedpoints.toString() + " + ",
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 75, 236, 43),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              //fontWeight: FontWeight.w700,
                              height: 0.9),
                        ),
                      ],
                    ),
                  ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 242, 240, 240),
                //border: Border.all(color: Colors.black),
              ),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 1,
              child: Row(
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  const Text(
                    "  المجموع   ",
                    //textAlign: TextAlign.right,
                    //textDirection: TextDirection.ltr,
                    style: TextStyle(
                        color: Color.fromRGBO(32, 26, 37, 1),
                        fontSize: 20,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.w700,
                        height: 0.9),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.46,
                  ),
                  Text(
                    total.toString() + " ريال",
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 17, 18, 18),
                        fontSize: 20,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        //fontWeight: FontWeight.w700,
                        height: 0.9),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
