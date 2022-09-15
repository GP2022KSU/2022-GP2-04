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
              CheckPoints(),
            ],
          ),
        ));
  }

  Widget CheckPoints() {
    return FutureBuilder<int>(
        future: user.BringnumOfObtPoints(),
        builder: (BuildContext context, AsyncSnapshot<int> asyn) {
          if (asyn.data == 0 || asyn.data == 1) {
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
            return PointsHistory();
          }
        });
  }

  Widget PointsHistory() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      width: MediaQuery.of(context).size.width * 0.9,
      //color: Colors.black,
      child: FutureBuilder<int>(
          future: user.BringnumOfObtPoints(),
          builder: (BuildContext context, AsyncSnapshot<int> asyn) {
            if (FirebaseAuth.instance.currentUser != null) {
              //user.getProducts();
              String a = asyn.data.toString();
              if (asyn.hasData) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.713,
                  child: FirebaseAnimatedList(
                      query: _fb.ref().child(
                          "Shopper/${FirebaseAuth.instance.currentUser?.uid}/PointsHistory"),
                      duration: const Duration(milliseconds: 500),
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        bool check = true;
                        //numOfProducts = user.getnumOfProducts();
                        var v = snapshot.value
                            .toString(); //Gets the scanned product and store it in a var
                        var g = v.replaceAll(
                            //Using RegExp to remove unwanted data
                            RegExp("{|}|Date:|GainedPoints:|numOfObtPoints:"),
                            "");
                        g.trim();

                        var l = g.split(',');
                        print(l.toString());
                        if (l[0] == user.getnumOfObtPoints().toString()) {
                          check = false;
                        }
                        /*
                        String word = l[0];
                        if (word[1] == "+") {
                          color = "green";
                        }
                        */
                        if (check) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 0,
                              child: FadeInAnimation(
                                child: ListTile(
                                  trailing: Text(
                                    l[1].toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                  leading: Text(
                                    l[0].toString(),
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
                );
              }
              return Container();
            }
            return Container();
          }),
    );
  }
}
