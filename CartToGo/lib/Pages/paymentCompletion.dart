import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carttogo/main.dart';
import 'dart:io';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import '../main.dart';
import 'package:carttogo/Users/user.dart' as user;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

final _fb = FirebaseDatabase.instance;

class PaymentCompletion extends StatefulWidget {
  String scanData;
  bool checkPay = false;
  PaymentCompletion(this.scanData);
  @override
  State<PaymentCompletion> createState() => PaymentCompletionState(scanData);
}

class PaymentCompletionState extends State<PaymentCompletion> {
  late String scanData;
  PaymentCompletionState(this.scanData);
  @override
  final _formKey = GlobalKey<FormState>();
  var inoviceQRController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    setState(() => inoviceQRController.text = scanData);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: appColor,
          ),
          backgroundColor: Colors.white,
          title: const Text("اتمام عملية الدفع",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(
            heightFactor: 2,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                Text(
                  "(" +
                      user.getnumOfProducts().toString() +
                      ")" +
                      "السلة الخاصة بـ",
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(
                      color: const Color.fromRGBO(32, 26, 37, 1),
                      fontSize: 20,
                      letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.w700,
                      height: 0.9),
                ),
                FutureBuilder<String>(
                    future: user.BirngUsername(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> asyn) {
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
                    }),
                Cart(),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(8.0),
                        textStyle: MaterialStateProperty.all(const TextStyle(
                            fontSize: 20, fontFamily: 'CartToGo')),
                        fixedSize:
                            MaterialStateProperty.all(const Size(200, 50)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                        backgroundColor: MaterialStateProperty.all(appColor),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    onPressed: () {
                      return _showMyDialog();
                    },
                    child: const Text('اتمام الدفع')),
              ],
            )));
  }

  Widget Cart() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.9,
      //color: Colors.black,
      child: FutureBuilder<int>(
          future: user.BringLastCartNumber(),
          builder: (BuildContext context, AsyncSnapshot<int> asyn) {
            if (FirebaseAuth.instance.currentUser != null) {
              final ref = _fb.ref().child(
                  "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/${asyn.data}");
              print("Successful ${asyn.data}");
              String a = asyn.data.toString();
              if (asyn.hasData) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.713,
                  child: FirebaseAnimatedList(
                      query: _fb.ref().child(
                          "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/${asyn.data}"),
                      duration: const Duration(milliseconds: 500),
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        //numOfProducts = user.getnumOfProducts();
                        var v = snapshot.value
                            .toString(); //Gets the scanned product and store it in a var
                        bool checker = true;
                        bool checke2 = true;

                        //print(v[0]);
                        try {
                          if (v[0] == "0" && v[1].isNotEmpty) {}
                        } on RangeError {
                          //If there is any kind of range error to avoid errors on the app
                          checker = false;
                          var g = v.replaceAll(RegExp("{|}|0: "), "");
                        }
                        var g = v.replaceAll(
                            //Using RegExp to remove unwanted data
                            RegExp(
                                "{|}|Name: |Price: |Size: |Category: |Brand: |Barcode: |Paid:"),
                            "");

                        g.trim();

                        var l = g.split(',');
                        //print("Data" + l.toString());
                        if (l.toString() == "[true]" ||
                            l.toString() == "[false]") {
                          print(l.toString());
                          checke2 = false;
                          if (l.toString() == "[true]") {
                            //checkPay = true;
                          }
                        }

                        if (!(l[0] == "0") && checker && checke2) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 0,
                              child: FadeInAnimation(
                                child: ListTile(
                                  trailing: Text(
                                    l[2],
                                    textAlign: TextAlign.center,
                                  ),
                                  leading: Text(
                                    l[5] + " ريال",
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        return Container();
                      }),
                );
              }
              return Container();
            }
            return Container();
          }),
    );
  }

  void _showMyDialog() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
              textDirection: TextDirection.rtl,
              child: Dialog(
                  elevation: 0,
                  backgroundColor: Color(0xffffffff),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    SizedBox(height: 15),
                    Text(
                      "هل تمت عملية الدفع؟",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: InkWell(
                            highlightColor: Colors.grey[200],
                            child: Center(
                                child: Text("نعم",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ))))),
                    Divider(
                      height: 1,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: InkWell(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0)),
                            highlightColor: Colors.grey[200],
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Center(
                                child: Text("لا",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                    )))))
                  ])));
        });
  }
}
