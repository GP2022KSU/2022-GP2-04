import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:carttogo/widgets/CartInstructions.dart';
import 'package:carttogo/widgets/ShoppingCartWidget.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({Key? key}) : super(key: key);

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  bool ConnectedToCart = false;
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
            child:
                ConnectedToCart ? ShoppingCartWidget() : CartInstructions()));
  }
}
