import 'package:carttogo/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:carttogo/widgets/cardHistory.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carttogo/Users/user.dart' as user;

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
