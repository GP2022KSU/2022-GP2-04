import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carttogo/Users/user.dart' as user;

class Cardhistory extends StatefulWidget {
  @override
  _CardhistoryState createState() => _CardhistoryState();
}

final _fb = FirebaseDatabase.instance;

class _CardhistoryState extends State<Cardhistory> {
  @override
  Widget build(BuildContext context) {
    return Card(
        shadowColor: Color.fromARGB(66, 13, 13, 13),
        elevation: 10,
        color: Color.fromARGB(255, 248, 245, 245),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.94,
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(16),
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
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/Card11.png'),
                          fit: BoxFit.fitWidth),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                    child: Container(
                        child: Transform.rotate(
                  angle: -1.2492672422141295e-13 * (math.pi / 180),
                  child: Text(
                    'لا يوجد سجل للنقاط',
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
                                          fontSize: 15,
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
                                          fontSize: 15,
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
                                          fontSize: 16,
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
                                            fontSize: 15,
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
                            Divider(thickness: 1),
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
}
