// ignore_for_file: unnecessary_const
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import '../main.dart';
import '../widgets/ShoppingCartWidget.dart';
import 'Navigation.dart';
import 'package:carttogo/Users/user.dart' as user;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';

final _fb = FirebaseDatabase.instance;

class CheckOut extends StatefulWidget {
  //int numOfProducts;
  //CheckOut({required this.numOfProducts});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  bool vis = false;
  int pointsChange = user.getPoints();
  double Total = user.getTotal();
  late double TotalInCart;
  late double PriceAfterPoin;
  bool checkPay = false;
  late bool _isLoading;
  late StreamSubscription _streamSubscription4;
  final _database = FirebaseDatabase.instance.ref();
  int GainedPoints = 0;

  void initState() {
    _isLoading = true;

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });

    _activateListeners();
    _showMyDialog(context);
    user.getPoints();
    pointsChange = user.getPoints();
    user.getTotal();
    super.initState();
  }

  Future<void> _showMyDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            StatefulBuilder(builder: (context, setState) {
              if (FirebaseAuth.instance.currentUser != null) {
                if (!(checkPay)) {
                  _streamSubscription4 = _database
                      .child(
                          "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/${user.getLastCartNum()}/Paid")
                      .onValue
                      .listen((event) {
                    final data = event.snapshot.value;
                    setState(() {
                      String Fornow = "false";
                      Fornow = data.toString();
                      if (Fornow.toLowerCase() == 'true') {
                        checkPay = true;
                      } else if (Fornow.toLowerCase() == 'false') {
                        checkPay = false;
                      }
                    });
                  });
                }
              }
              return FutureBuilder<String>(
                  future: user.BringLoyaltyCardID(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> LoyaltyID) {
                    return Directionality(
                        textDirection: TextDirection.rtl,
                        child: Dialog(
                          elevation: 0,
                          backgroundColor: const Color(0xffffffff),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            const SizedBox(height: 15),
                            Card(
                                shadowColor: Color.fromARGB(255, 0, 0, 0),
                                elevation: 15,
                                color: const Color.fromARGB(165, 255, 255, 255),
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: MediaQuery.of(context).size.height *
                                        0.27,
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    child: Column(children: [
                                      Container(
                                        child: QrImage(
                                          foregroundColor: Colors.black,
                                          gapless: true,
                                          embeddedImage: const AssetImage(
                                              'assets/images/logomini.png'),
                                          data: user
                                                  .getLoyaltyCardID()
                                                  .toString() +
                                              " - " +
                                              user
                                                  .getLastCartNum()
                                                  .toString(), //ID for the card
                                          version: QrVersions.auto,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Text(
                                            user
                                                .getLoyaltyCardID()
                                                .toString(), //text
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                shadows: <Shadow>[
                                                  const Shadow(
                                                    offset:
                                                        const Offset(0.5, 0.5),
                                                    blurRadius: 1,
                                                    color: Color.fromARGB(
                                                        162, 63, 63, 63),
                                                  )
                                                ],
                                                fontFamily: 'CartToGo',
                                                fontSize: 20,
                                                letterSpacing: -0.5,
                                                fontWeight: FontWeight.w500,
                                                height: 1),
                                          )),
                                    ]))),
                            const SizedBox(height: 15),
                            const Text("قم بالمسح عند المحاسب",
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                )),
                            const SizedBox(height: 15),
                            Visibility(
                              visible: checkPay,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(8.0),
                                      textStyle: MaterialStateProperty.all(
                                          const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'CartToGo')),
                                      fixedSize: MaterialStateProperty.all(
                                          const Size(150, 30)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                      backgroundColor:
                                          MaterialStateProperty.all(appColor),
                                      foregroundColor: MaterialStateProperty.all(
                                          Colors.white)),
                                  onPressed: () async {
                                    if (vis) {
                                      double dpoints = 0;
                                      for (var i = 0;
                                          i < user.getTotalAfterPoints();
                                          i++) {
                                        dpoints += 0.1;
                                      }
                                      GainedPoints =
                                          int.parse(dpoints.toStringAsFixed(0));
                                      print("Points Gained true: " +
                                          GainedPoints.toString());
                                    } else {
                                      double dpoints = 0;
                                      for (var i = 0;
                                          i < user.getTotal();
                                          i++) {
                                        dpoints += 0.1;
                                      }
                                      GainedPoints =
                                          int.parse(dpoints.toStringAsFixed(0));
                                      print("Points Gained false: " +
                                          GainedPoints.toString());
                                    }
                                    if (checkPay) {
                                      Navigator.of(context).pop();
                                      return _showMyDialogShowPoints(context);
                                    }
                                  },
                                  child: const Text('استرداد النقاط')),
                            ),
                            const SizedBox(height: 15),
                          ]),
                        ));
                  });
            }));
  }

  Future<void> _showMyDialogShowPoints(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            StatefulBuilder(builder: (context, setState) {
              setState(() {});
              return FutureBuilder<String>(
                  future: user.BringLoyaltyCardID(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> LoyaltyID) {
                    return Directionality(
                        textDirection: TextDirection.rtl,
                        child: Dialog(
                          elevation: 0,
                          backgroundColor: const Color(0xffffffff),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            const SizedBox(height: 15),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.2,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    scale: 10,
                                    image:
                                        AssetImage('assets/images/points.png'),
                                    fit: BoxFit.fitHeight),
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text("لقد كسبت",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(GainedPoints.toString(), //POINTS HERE
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 10, 70, 175))),
                            const SizedBox(height: 15),
                            ElevatedButton(
                                style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(8.0),
                                    textStyle: MaterialStateProperty.all(
                                        const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'CartToGo')),
                                    fixedSize: MaterialStateProperty.all(
                                        const Size(150, 30)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    backgroundColor:
                                        MaterialStateProperty.all(appColor),
                                    foregroundColor: MaterialStateProperty.all(
                                        Colors.white)),
                                onPressed: () async {
                                  DatabaseReference ref2 =
                                      FirebaseDatabase.instance.ref(
                                          "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts");
                                  await ref2.update({
                                    "ConnectedToCart": false,
                                    "Total": 0,
                                    "NumOfProducts": 0,
                                  });
                                  DatabaseReference ref3 =
                                      FirebaseDatabase.instance.ref(
                                          "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/${user.getLastCartNum()}");
                                  await ref3.update({
                                    "Total": vis
                                        ? user.getTotalAfterPoints()
                                        : Total,
                                  });
                                  var currDt = DateTime.now();
                                  String date = currDt.day.toString() +
                                      "-" +
                                      currDt.month.toString() +
                                      "-" +
                                      currDt.year.toString();
                                  if (vis) {
                                    //if points are used
                                    DatabaseReference ref4 =
                                        FirebaseDatabase.instance.ref(
                                            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/PointsHistory/${user.getnumOfObtPoints()}");
                                    await ref4.set({
                                      "Date": date,
                                      "GainedPoints":
                                          "-" + pointsChange.toString(),
                                    });
                                    DatabaseReference ref5 =
                                        FirebaseDatabase.instance.ref(
                                            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/PointsHistory/${user.getnumOfObtPoints() + 1}");
                                    await ref5.set({
                                      "Date": date,
                                      "GainedPoints":
                                          "+" + GainedPoints.toString(),
                                    });

                                    DatabaseReference ref6 =
                                        FirebaseDatabase.instance.ref(
                                            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/PointsHistory");
                                    await ref6.update({
                                      "numOfObtPoints":
                                          (user.getnumOfObtPoints() + 2)
                                    });

                                    DatabaseReference ref7 =
                                        FirebaseDatabase.instance.ref(
                                            "Shopper/${FirebaseAuth.instance.currentUser?.uid}");
                                    await ref7.update({
                                      "Points": GainedPoints,
                                    });
                                  } else {
                                    DatabaseReference ref5 =
                                        FirebaseDatabase.instance.ref(
                                            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/PointsHistory/${user.getnumOfObtPoints()}");
                                    await ref5.set({
                                      "Date": date,
                                      "GainedPoints":
                                          "+" + GainedPoints.toString(),
                                    });
                                    DatabaseReference ref7 =
                                        FirebaseDatabase.instance.ref(
                                            "Shopper/${FirebaseAuth.instance.currentUser?.uid}");
                                    await ref7.update({
                                      "Points": GainedPoints + user.getPoints(),
                                    });
                                    DatabaseReference ref6 =
                                        FirebaseDatabase.instance.ref(
                                            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/PointsHistory");
                                    await ref6.update({
                                      "numOfObtPoints":
                                          (user.getnumOfObtPoints() + 1)
                                    });
                                  }
                                  if (checkPay) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Navi()));
                                  }
                                },
                                child: const Text('الرئيسية')),
                            const SizedBox(height: 15),
                          ]),
                        ));
                  });
            }));
  }

  bool _activateListeners() {
    _streamSubscription4 = _database
        .child(
            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/${user.getLastCartNum()}/Total")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      setState(() {
        TotalInCart = double.parse(event.snapshot.value.toString());
      });
    });
    if (FirebaseAuth.instance.currentUser != null) {
      _streamSubscription4 = _database
          .child(
              "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/${user.getLastCartNum()}/Paid")
          .onValue
          .listen((event) {
        final data = event.snapshot.value;
        setState(() {
          String Fornow = "false";
          Fornow = data.toString();
          if (Fornow.toLowerCase() == 'true') {
            checkPay = true;
          } else if (Fornow.toLowerCase() == 'false') {
            checkPay = false;
          }
        });
      });
      return checkPay;
    }
    return checkPay;
  }

  void _changed(bool visibility, bool field) {
    setState(() {
      if (field == true) {
        vis = visibility;
      }
      if (field == false) {
        vis = visibility;
      }
    });
  }

  Widget build(BuildContext context) {
    //final checkpay = Provider.of<Navi>(context, listen: true);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: appColor),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Navi();
                }));
              }),
          backgroundColor: const Color.fromARGB(231, 255, 255, 255),
          title: const Text("مراجعة السلة",
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
                      " السلة", //Product name 1 android 2 ios
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
                Cart(),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 242, 240, 240),
                    //border: Border.all(color: Colors.black),
                  ),
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      const Text(
                        "  استخدام النقاط    ",
                        //textAlign: TextAlign.right,
                        //textDirection: TextDirection.ltr,
                        style: const TextStyle(
                            color: Color.fromRGBO(32, 26, 37, 1),
                            fontSize: 20,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.w700,
                            height: 0.9),
                      ),
                      Text(
                        "(" + user.getPoints().toString() + ")",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 101, 204, 140),
                            fontSize: 20,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.w700,
                            height: 0.9),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 6, bottom: 10),
                          child: LiteRollingSwitch(
                            animationDuration:
                                const Duration(milliseconds: 200),
                            width: 80,
                            value: false,
                            textOn: "نعم",
                            textOff: "لا",
                            colorOn: Colors.greenAccent,
                            colorOff: Colors.redAccent,
                            textSize: 10,
                            iconOn: Icons.circle_sharp,
                            iconOff: Icons.circle_sharp,
                            onChanged: (bool postion) {
                              if (user.getPoints() > 0) {
                                setState(() {
                                  if (postion == true) {
                                    _changed(true, postion);
                                  } else {
                                    _changed(false, postion);
                                  }
                                });
                              }
                            },
                            onDoubleTap: () {},
                            onSwipe: () {},
                            onTap: () {},
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
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
                        user.getTotal().toString() + " ريال",
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                            color: const Color.fromARGB(255, 17, 18, 18),
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
                  height: 20,
                ),
                Visibility(
                  visible: vis,
                  child: Container(
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
                          "  المجموع بعد النقاط  ",
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
                          width: MediaQuery.of(context).size.width * 0.313,
                        ),
                        Text(
                          user.getTotalAfterPoints().toString() + " ريال",
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                              color: const Color.fromARGB(255, 17, 18, 18),
                              fontSize: 20,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              //fontWeight: FontWeight.w700,
                              height: 0.9),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
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
                    onPressed: () async {
                      DatabaseReference ref3 = FirebaseDatabase.instance.ref(
                          "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/${user.getLastCartNum()}");
                      await ref3.update({
                        "Total": vis ? user.getTotalAfterPoints() : Total,
                      });
                      await _showMyDialog(context);
                    },
                    child: const Text('اتمام الدفع')),
                //end of login button
              ],
            )));
  }

  @override
  void deactivate() {
    _streamSubscription4.cancel();
    super.deactivate();
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
                                "{|}|Name: |Price: |Size: |Category: |Brand: |Barcode: |Paid: | Total:"),
                            "");

                        g.trim();

                        var l = g.split(',');
                        if (l[0] == TotalInCart.toString()) {
                          checke2 = false;
                        }
                        if (l.toString() == "[true]" ||
                            l.toString() == "[false]" ||
                            l[0] == TotalInCart.toStringAsFixed(0)) {
                          //print(l.toString());
                          checke2 = false;
                        }

                        if (!(l[0] is double) && checker && checke2) {
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
}
