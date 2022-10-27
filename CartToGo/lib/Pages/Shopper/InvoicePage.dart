import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

// ignore: must_be_immutable
class InvoicePage extends StatefulWidget {
  String cartID;
  int numOfproducts;
  InvoicePage(this.cartID, this.numOfproducts, {Key? key}) : super(key: key);
  @override
  State<InvoicePage> createState() => _InvoicePageState(cartID, numOfproducts);

  static invoicepage() {}

  static invoice(String s, int i) {}
}

class _InvoicePageState extends State<InvoicePage> {
  String cartID;
  int numOfproducts;
  _InvoicePageState(this.cartID, this.numOfproducts);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          cartID,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
