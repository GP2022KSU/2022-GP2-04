import 'package:carttogo/Pages/welcome_page.dart';
import 'package:carttogo/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:carttogo/widgets/cardHistory.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carttogo/Users/user.dart' as user;
import 'package:firebase_auth/firebase_auth.dart';

class LoyaltyCard extends StatelessWidget {
  String checkPointText() {
    if (user.getPoints() == 2) {
      return "نقطتان";
    }
    if (user.getPoints() >= 3 && CardWidgetState().points < 10) {
      print("Here");
      return "نقاط";
    }
    print(user.getPoints());
    return "نقطة";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white24,
        appBar: AppBar(
          backgroundColor: Colors.white24,
          title: const Text(
            "بطاقة الولاء",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'CartToGo',
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(3),
                      textStyle: MaterialStateProperty.all(const TextStyle(
                          fontSize: 17,
                          fontFamily: 'CartToGo',
                          fontWeight: FontWeight.bold)),
                      fixedSize: MaterialStateProperty.all(const Size(70, 10)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();

                    print("UID: ${FirebaseAuth.instance.currentUser?.uid}");

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => WelcomePage()));
                  },
                  child: const Text('خروج')),
            ),
          ],
          centerTitle: true,
          elevation: 0,
        ),
        body: ListView(children: <Widget>[
          Column(children: <Widget>[
            Center(
              heightFactor: 1,
              child: CardWidget(),
            ),
            Center(
              heightFactor: 1.04,
              child: Cardhistory(),
            ),
          ])
        ]));
  }
}
