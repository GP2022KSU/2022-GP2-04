import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:carttogo/Users/user.dart' as user;

class CardWidget extends StatefulWidget {
  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  String _points = "";
  String userid = "Stu2LFiw98aJfRWU445Tw73oYnD3";
  final _database = FirebaseDatabase.instance.ref();
  late StreamSubscription _streamSubscription;
  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  void _activateListeners() {
    _streamSubscription =
        _database.child("Shopper/$userid/Points").onValue.listen((event) {
      final point = event.snapshot.value;
      setState(() {
        _points = point.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.94,
      height: MediaQuery.of(context).size.width * 0.51,
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
                  width: 112.04571533203125,
                  height: 36.0905647277832,
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: 112.04571533203125,
                            height: 36.0905647277832,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              //color: Colors.transparent,
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
                        child: Text(
                          _points, //points text
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              height: 0.9),
                        )),
                    Positioned(
                        top: 10.025157928466797,
                        left: 13.293527603149414,
                        child: Text(
                          'نقطة',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.125),
                        )),
                  ]))),
          Positioned(
              top: 57,
              left: 43,
              child: Text(
                user.getUsername(), //text username
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 0.9),
              )),
          Positioned(
              top: 10,
              left: 200,
              child: Card(
                  shadowColor: Color.fromARGB(255, 23, 16, 222),
                  elevation: 15,
                  color: Color.fromARGB(165, 255, 255, 255),
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                      width: 150,
                      height: 175,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      )))),
          Positioned(
              top: 170,
              left: 225,
              child: Text(
                user.getLoyaltyCardID(), //text
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(0.5, 0.5),
                        blurRadius: 1,
                        color: Color.fromARGB(162, 63, 63, 63),
                      )
                    ],
                    fontFamily: 'Inter',
                    fontSize: 20,
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.w500,
                    height: 1),
              )),
          Positioned(
            top: 12,
            left: 197.5,
            child: QrImage(
              foregroundColor: Colors.black,
              gapless: true,
              embeddedImage: AssetImage('assets/images/logomini.png'),
              data: user.getLoyaltyCardID(), //ID for the card
              version: QrVersions.auto,
              size: 163,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void deactivate() {
    _streamSubscription.cancel();
    super.deactivate();
  }
}
