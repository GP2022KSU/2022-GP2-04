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
          height: MediaQuery.of(context).size.height * 0.713,
          child: FirebaseAnimatedList(
              query: _fb.ref().child(
                  "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts"),
              duration: const Duration(milliseconds: 500),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                final map = snapshot.value as Map<dynamic, dynamic>;
                String InvoiceNumber = snapshot.key.toString();
                double total = 0;
                map.forEach((key, value) {
                  if (key == "CartInfo") {
                    total = double.parse(value['Total'].toString());
                  }
                });
                if (map['NumOfProducts'] == null) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 0,
                      child: FadeInAnimation(
                        child: ListTile(
                          trailing: Text(
                            InvoiceNumber + " #",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          leading: Text(
                            total.toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
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
