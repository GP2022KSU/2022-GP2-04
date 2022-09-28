import 'package:carttogo/Pages/Cashier.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carttogo/main.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../main.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:carttogo/Users/Cashier.dart' as cashier;

final _fb = FirebaseDatabase.instance;

class PaymentCompletion extends StatefulWidget {
  String scanData;
  PaymentCompletion(this.scanData);
  @override
  State<PaymentCompletion> createState() => PaymentCompletionState(scanData);
}

class PaymentCompletionState extends State<PaymentCompletion> {
  late bool _isLoading1;
  String scanData;
  PaymentCompletionState(this.scanData);

  @override
  final _formKey = GlobalKey<FormState>();
  var inoviceQRController = TextEditingController();
  var splitted;
  final _database = FirebaseDatabase.instance.ref();
  late String uid;
  late double TotalBefore;
  late StreamSubscription _streamSubscription;
  late double TotalInCart = 0;

  void initState() {
    _isLoading1 = true;

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          /*
          _streamSubscription = _database
              .child("Shopper/${uid}/Carts/${splitted[1].toString()}/Total")
              .onValue
              .listen((event) {
            final data = event.snapshot.value;
            TotalInCart = double.parse(event.snapshot.value.toString());
          });
          */
          _isLoading1 = false;
        });
      }
    });
    //_activateListeners();
    super.initState();
  }

/*
  void _activateListeners() {
    _streamSubscription = _database
        .child("Shopper/${uid}/Carts/${splitted[1].toString()}/Total")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      setState(() {
        TotalInCart = double.parse(event.snapshot.value.toString());
      });
    });
  }
*/
  @override
  Widget build(BuildContext context) {
    setState(() => splitted = scanData.split(' - '));
    uid = cashier.getUID(splitted[0]);
    TotalBefore = cashier.getTotalAfterPoints(uid, int.parse(splitted[1]));
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(
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
            child: FutureBuilder<String>(
                future: cashier.BringUID(splitted[0].toString()),
                builder: (BuildContext context, AsyncSnapshot<String> asyn) {
                  if (FirebaseAuth.instance.currentUser != null) {
                    //String uid = asyn.data.toString();
                    return Column(
                      children: <Widget>[
                        // review the shopping cart by the cashier which include,
                        // shopper's name, number of products in the cart, and the total price
                        /*
                        const SizedBox(height: 20),
                        Text(
                          "(" +
                              cashier.getnumOfProducts(uid).toString() +
                              ") " +
                              cashier.getUsername(uid).toString() +
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
                        )*/
                        Cart(),

                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: const Color.fromARGB(255, 242, 240, 240),
                            //border: Border.all(color: Colors.black),
                          ),
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 1,
                          child: Row(
                            textDirection: TextDirection.rtl,
                            children: <Widget>[
                              const Text(
                                "  المجموع   ",
                                //textAlign: TextAlign.right,
                                //textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    color: Color.fromRGBO(32, 26, 37, 1),
                                    fontSize: 20,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.w700,
                                    height: 0.9),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.54,
                              ),
                              Text(
                                cashier
                                        .getTotalAfterPoints(
                                            asyn.data.toString(),
                                            int.parse(splitted[1]))
                                        .toString() +
                                    " ريال",
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                    color:
                                        const Color.fromARGB(255, 17, 18, 18),
                                    fontSize: 20,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    //fontWeight: FontWeight.w700,
                                    height: 0.9),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        // payment completion button
                        ElevatedButton(
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(8.0),
                                textStyle: MaterialStateProperty.all(
                                    const TextStyle(
                                        fontSize: 20, fontFamily: 'CartToGo')),
                                fixedSize: MaterialStateProperty.all(
                                    const Size(200, 50)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0))),
                                backgroundColor:
                                    MaterialStateProperty.all(appColor),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                            onPressed: () {
                              return _showMyDialog();
                            },
                            child: const Text('اتمام الدفع')),
                        // end of payment completion button
                      ],
                    );
                  }
                  return Container();
                })));
  }

  Widget Cart() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 1,
      child: FutureBuilder<String>(
          future: cashier.BringUID(splitted[0].toString()),
          builder: (BuildContext context, AsyncSnapshot<String> asyn) {
            if (FirebaseAuth.instance.currentUser != null) {
              uid = asyn.data.toString();
              if (asyn.hasData) {
                return Column(children: [
                  const SizedBox(height: 20),
                  Text(
                    "(" +
                        cashier
                            .getnumOfProducts(asyn.data.toString())
                            .toString() +
                        ") " +
                        cashier.getUsername(asyn.data.toString()).toString() +
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
                  Container(
                    height: MediaQuery.of(context).size.height * 0.713,
                    child: FirebaseAnimatedList(
                        query: _fb.ref().child(
                            "Shopper/${asyn.data.toString()}/Carts/${splitted[1].toString()}"),
                        duration: const Duration(milliseconds: 500),
                        itemBuilder: (BuildContext context,
                            DataSnapshot snapshot,
                            Animation<double> animation,
                            int index) {
                          //numOfProducts = user.getnumOfProducts();
                          var v = snapshot.value
                              .toString(); //Gets the scanned product and store it in a var
                          bool checker = true;
                          bool checke2 = true;

                          String Name = "";
                          double Price = 0;
                          bool HaveOffer = false;

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
                          if (l[0] == TotalInCart.toString()) {
                            checke2 = false;
                          }

                          if (l.toString() == "[true]" ||
                              l.toString() == "[false]" ||
                              l[0] == TotalInCart.toStringAsFixed(0)) {
                            checke2 = false;
                            if (l.toString() == "[true]") {
                              //checkPay = true;
                            }
                          }

                          if (!(l[0] == "0") && checker && checke2) {
                            try {
                              var map = snapshot.value as Map<dynamic, dynamic>;
                              Name = map['Name'];
                              HaveOffer = map['Offer'];
                              HaveOffer
                                  ? Price = double.parse(
                                      map['PriceAfterOffer'].toString())
                                  : Price = map['Price'];
                            } on Exception {
                              checker = false;
                            }
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 0,
                                child: FadeInAnimation(
                                  child: ListTile(
                                    trailing: Text(
                                      Name,
                                      textAlign: TextAlign.center,
                                    ),
                                    leading: Text(
                                      Price.toString() + " ريال",
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
                  ),
                ]);
              }
              return Container();
            }
            return Container();
          }),
    );
  }

// dialog for the cashier to checks whether the shopper has paid or not
  void _showMyDialog() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
              textDirection: TextDirection.rtl,
              child: Dialog(
                  elevation: 0,
                  backgroundColor: const Color(0xffffffff),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(height: 15),
                    const Text(
                      "هل تمت عملية الدفع؟",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Divider(
                      height: 1,
                      color: Colors.black,
                    ),

                    // if the shopper has paid, navigate to the cashier's homepage
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: InkWell(
                            highlightColor: Colors.grey[200],
                            onTap: () async {
                              DatabaseReference ref3 = FirebaseDatabase.instance
                                  .ref(
                                      "Shopper/${uid}/Carts/${splitted[1].toString()}");
                              await ref3.update({
                                "Paid": true,
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Cashier()));
                            },
                            child: const Center(
                                child: const Text("نعم",
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ))))),
                    const Divider(
                      height: 1,
                    ),

                    // if the  shopper doesn't paid, close the dialog and stay in review shopping cart
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: InkWell(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15.0),
                                bottomRight: const Radius.circular(15.0)),
                            highlightColor: Colors.grey[200],
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Center(
                                child: const Text("لا",
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    )))))
                  ])));
        });
  }
/*
  void deactivate() {
    _streamSubscription.cancel();
    super.deactivate();
  }
  */
}
