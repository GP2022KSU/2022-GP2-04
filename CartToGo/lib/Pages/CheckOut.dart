import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import '../widgets/ShoppingCartWidget.dart';
import 'Navigation.dart';
import 'package:carttogo/Users/user.dart' as user;
import 'package:flutter_slidable/flutter_slidable.dart';

final _fb = FirebaseDatabase.instance;

class CheckOut extends StatefulWidget {
  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  Widget build(BuildContext context) {
    final _fb = FirebaseDatabase.instance;
    return Scaffold(
        backgroundColor: Color.fromARGB(231, 249, 248, 248),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Navi();
              }));
            },
          ),
          backgroundColor: Color.fromARGB(231, 255, 255, 255),
          title: Text(
            "سلة التسوق",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'CartToGo',
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(3),
                      textStyle: MaterialStateProperty.all(const TextStyle(
                          fontSize: 14,
                          fontFamily: 'CartToGo',
                          fontWeight: FontWeight.bold)),
                      fixedSize: MaterialStateProperty.all(const Size(70, 10)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () async {
                    //_showMyDialog();
                  },
                  child: const Text('خروج')),
            ),
          ],
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(
          heightFactor: 1.6,
          child: Cart(),
        ));
  }

  Widget Cart() {
    return FutureBuilder<int>(
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
                    duration: Duration(milliseconds: 500),
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      //numOfProducts = user.getnumOfProducts();

                      var v = snapshot.value
                          .toString(); //Gets the scanned product and store it in a var
                      bool checker = true;
                      print(v[0]);
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
                              "{|}|Name: |Price: |Size: |Category: |Brand: |Barcode: "),
                          "");

                      g.trim();

                      var l = g.split(',');
                      print("Data" + l.toString());

                      if (!(l[0] == "0") && checker) {
                        return ListTile(
                          title: Text(l[2]),
                        );
                      }
                      return Container();
                    }),
              );
            }
            return Container();
          }
          return Container();
        });
  }
}
