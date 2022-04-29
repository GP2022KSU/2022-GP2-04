import 'package:flutter/material.dart';

class ShoppingCartWidget extends StatefulWidget {
  const ShoppingCartWidget({Key? key}) : super(key: key);

  @override
  State<ShoppingCartWidget> createState() => _ShoppingCartWidgetState();
}

class _ShoppingCartWidgetState extends State<ShoppingCartWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "cart", //text
        textAlign: TextAlign.center,
      ),
    );
  }
}
