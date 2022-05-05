// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new

import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:carttogo/Users/user.dart' as user;
import 'package:carttogo/Pages/LoyaltyCard.dart';
import 'package:carttogo/Users/userData.dart';

class CardWidget extends StatefulWidget {
  @override
  CardWidgetState createState() => CardWidgetState();
}

class CardWidgetState extends State<CardWidget> {
  int points = 0;
  String userid = "Stu2LFiw98aJfRWU445Tw73oYnD3"; //Change to real id
  final _database = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.94,
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 37, 9, 179),
            Color.fromARGB(255, 63, 60, 255)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
              color: Color.fromARGB(62, 129, 129, 129),
              offset: Offset(8, 8),
              blurRadius: 25)
        ],
        image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Color.fromARGB(255, 37, 9, 179).withOpacity(0.2),
                BlendMode.dstATop),
            image: AssetImage('assets/images/Cart21.png'),
            fit: BoxFit.fitWidth),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
              top: 110,
              left: 26,
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.27,
                  height: 37,
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.27,
                            height: 37,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(60, 77, 75, 75),
                                    offset: Offset(8, 8),
                                    spreadRadius: 5,
                                    blurRadius: 25)
                              ],
                              gradient: LinearGradient(
                                  begin: Alignment(0, 1.6),
                                  end: Alignment(-1.6, 0),
                                  colors: [
                                    Color.fromARGB(60, 255, 255, 255),
                                    Color.fromARGB(10, 255, 255, 255),
                                  ]),
                            ))),
                    Positioned(
                        top: 10.025157928466797,
                        left: 80.0571403503418,
                        child: FutureBuilder<int>(
                            future: user.BringPoints(),
                            builder: (BuildContext context,
                                AsyncSnapshot<int> asyn) {
                              if (asyn.hasData) {
                                return Text(
                                  asyn.data.toString(), //points text
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Inter',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      height: 0.9),
                                );
                              }
                              return Text(
                                user.getPoints().toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Inter',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    height: 0.9),
                              );
                            })),
                    Positioned(
                        top: 10,
                        left: 13,
                        child: Text(
                          LoyaltyCard().checkPointText(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'CartToGo',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.125),
                        )),
                  ]))),
          Positioned(
              top: 57,
              left: 36,
              child: FutureBuilder<String>(
                  future: user.BirngUsername(),
                  builder: (BuildContext context, AsyncSnapshot<String> asyn) {
                    if (asyn.hasData) {
                      return Text(
                        user.getUsername(), //text username
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'CartToGo',
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            height: 0.9),
                      );
                    }
                    return Text(
                      user.getUsername().toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'CartToGo',
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          height: 0.9),
                    );
                  })),
          Positioned(
              top: 15,
              left: 200,
              child: Card(
                  shadowColor: Color.fromARGB(255, 23, 16, 222),
                  elevation: 15,
                  color: Color.fromARGB(165, 255, 255, 255),
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FutureBuilder<String>(
                              future: user.BringLoyaltyCardID(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> asyn) {
                                if (asyn.hasData) {
                                  return Text(
                                    asyn.data.toString(), //text
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(0.5, 0.5),
                                            blurRadius: 1,
                                            color:
                                                Color.fromARGB(162, 63, 63, 63),
                                          )
                                        ],
                                        fontFamily: 'CartToGo',
                                        fontSize: 20,
                                        letterSpacing: -0.5,
                                        fontWeight: FontWeight.w500,
                                        height: 1),
                                  );
                                }
                                return Text(
                                  user.getLoyaltyCardID(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(0.5, 0.5),
                                          blurRadius: 1,
                                          color:
                                              Color.fromARGB(162, 63, 63, 63),
                                        )
                                      ],
                                      fontFamily: 'CartToGo',
                                      fontSize: 20,
                                      letterSpacing: -0.5,
                                      fontWeight: FontWeight.w500,
                                      height: 1),
                                );
                              }))))),
          Positioned(
              top: 16,
              left: 199,
              child: FutureBuilder<String>(
                future: user.BringLoyaltyCardID(),
                builder: (BuildContext context, AsyncSnapshot<String> asyn) {
                  if (asyn.hasData) {
                    return QrImage(
                      foregroundColor: Colors.black,
                      gapless: true,
                      embeddedImage: AssetImage('assets/images/logomini.png'),
                      data: asyn.data.toString(), //ID for the card
                      version: QrVersions.auto,
                      size: MediaQuery.of(context).size.width * 0.37,
                    );
                  }
                  return QrImage(
                    foregroundColor: Colors.black,
                    gapless: true,
                    embeddedImage: AssetImage('assets/images/logomini.png'),
                    data: user.getLoyaltyCardID(), //ID for the card
                    version: QrVersions.auto,
                    size: MediaQuery.of(context).size.width * 0.37,
                  );
                },
              )),
        ],
      ),
    );
  }
}
