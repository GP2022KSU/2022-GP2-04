import 'package:carttogo/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:carttogo/widgets/cardHistory.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carttogo/Users/user.dart' as user;
class LoyaltyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //user.BringLoyaltyCardID;
    //user.BirngUsername;
    return Scaffold(
        backgroundColor: Colors.white24,
        appBar: AppBar(
          backgroundColor: Colors.white24,
          title: Text(
            "بطاقة الولاء",
            style: GoogleFonts.inter(
              textStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                //Directionality(
                //textDirection: Text.Direction.rtl,
                //),//Directionality
              ),
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(children: <Widget>[
          Center(
            heightFactor: 1,
            child: CardWidget(),
          ),
          Center(
            heightFactor: 1.04,
            child: Cardhistory(),
          ),
        ]));
  }
}
