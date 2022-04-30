// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:carttogo/widgets/CartInstructions.dart';
import 'package:carttogo/widgets/ShoppingCartWidget.dart';
import 'package:animated_button/animated_button.dart';

class ShoppingCart extends StatefulWidget {
  Function callback;
  ShoppingCart(this.callback);
  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  late bool ConnectedToCart=true;
  String userid = "Stu2LFiw98aJfRWU445Tw73oYnD3"; //Change to real id
  final _database = FirebaseDatabase.instance.ref();
  late StreamSubscription _streamSubscription;
  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  void _activateListeners() {
    _streamSubscription = _database
        .child("Shopper/$userid/Carts/ConnectedToCart")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;

      setState(() {
        String Fornow = "false";
        Fornow = data.toString();
        if (Fornow.toLowerCase() == 'true') {
          ConnectedToCart = true;
        } else if (Fornow.toLowerCase() == 'false') {
          ConnectedToCart = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white24,
        appBar: AppBar(
          backgroundColor: Colors.white24,
          title: Text(
            "سلة التسوق",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'CartToGo',
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(
            heightFactor: 1.6,
            child: ConnectedToCart ? ShoppingCartWidget() : Instructions()));
  }

  Widget Instructions() {
    Future.delayed(const Duration(milliseconds: 1000));
    return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        //color: Colors.black,
        child: Stack(children: [
          Positioned(
            top: 40,
            left: 20,
            child: Material(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(0.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: Offset(-10.0, 10.0),
                      blurRadius: 20,
                      spreadRadius: 4,
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 33,
            child: Card(
              elevation: 10,
              shadowColor: Colors.grey.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Color.fromARGB(255, 35, 61, 255),
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: AssetImage("assets/images/HandQR.png"),
                      ))),
            ),
          ),
          Positioned(
            top: 60,
            right: 190,
            child: Container(
              //color: Colors.black,
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.4,
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "لبدأ التسوق",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Divider(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      Text(
                        "مرر بطاقة الولاء",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
                          color: Color.fromARGB(255, 42, 41, 41),
                        ),
                      ),
                      Text(
                        "الخاصة بك الى",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
                          color: Color.fromARGB(255, 42, 41, 41),
                        ),
                      ),
                      Text(
                        "  السلة لربطها",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
                          color: Color.fromARGB(255, 42, 41, 41),
                        ),
                      ),
                      Text(
                        "  بسلتك الذكية",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
                          color: Color.fromARGB(255, 42, 41, 41),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ]),
              ),
            ),
          ),
          Positioned(
              top: 250,
              left: 55,
              child: Center(
                  child: AnimatedButton(
                child: Text(
                  'ابدأ',
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  widget.callback(1);
                },
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.1,
                //shadowDegree: ShadowDegree.light,
                color: Color.fromARGB(255, 35, 61, 255),
              ))),
        ]));
  }
}
