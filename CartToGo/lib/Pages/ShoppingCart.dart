import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({Key? key}) : super(key: key);

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
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
            //Directionality(
            //textDirection: Text.Direction.rtl,
            //),//Directionality
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(),
    );
  }
}
