// ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:carttogo/Users/user.dart' as user;
import 'package:carttogo/Users/Products.dart';

class ShoppingCartWidget extends StatefulWidget {
  //const ShoppingCartWidget({Key? key}) : super(key: key);
  bool callback;
  ShoppingCartWidget(this.callback);
  @override
  State<ShoppingCartWidget> createState() => ShoppingCartWidgetState(callback);
}

class ShoppingCartWidgetState extends State<ShoppingCartWidget> {
  bool callback;
  ShoppingCartWidgetState(this.callback);
  late int numOfProducts = 0;
  double totalCart = 0;
  late int LastCartNumber = 0;
  late bool ConnectedToCart = false;
  final _fb = FirebaseDatabase.instance;
  final _database = FirebaseDatabase.instance.ref();
  bool checkCartNumber = false;
  String userid = "Stu2LFiw98aJfRWU445Tw73oYnD3"; //Change to real id
  late StreamSubscription _streamSubscription;
  late StreamSubscription _streamSubscription1;
  @override
  void initState() {
    super.initState();
    _activateListeners();
    _CheckLastnumOfProd();
  }

  void _activateListeners() {
    _streamSubscription = _database
        .child("Shopper/$userid/Carts/ConnectedToCart")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      print("Data $data");
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

  Future<int> _CheckLastnumOfProd() async {
    _streamSubscription1 = _database
        .child("Shopper/$userid/Carts/numOfProducts")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      setState(() {
        numOfProducts = (int.parse(data.toString()));
      });
    });
    print("NumOfProducts: $numOfProducts");
    return numOfProducts;
  }

  @override
  Widget build(BuildContext context) {
    //print("2: "+_performSingleFetch().toString());
    //print(callback);
    //_performSingleFetch();
    //_activateListeners();
    print(ConnectedToCart);
    return Scaffold(body: Con());
  }

  Widget Cart() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<int>(
                future: user.BringLastCartNumber(),
                builder: (BuildContext context, AsyncSnapshot<int> asyn) {
                  final ref =
                      _fb.ref().child("Shopper/$userid/Carts/${asyn.data}");
                  print("Successful ${asyn.data}");
                  String a = asyn.data.toString();
                  if (asyn.hasData) {
                    return FirebaseAnimatedList(
                        query: _fb
                            .ref()
                            .child("Shopper/$userid/Carts/${asyn.data}"),
                        duration: Duration(milliseconds: 500),
                        itemBuilder: (BuildContext context,
                            DataSnapshot snapshot,
                            Animation<double> animation,
                            int index) {
                          numOfProducts = user.getnumOfProducts();
                          var v = snapshot.value.toString();
                          var g = v.replaceAll(
                              RegExp(
                                  "{|}|Name: |Price: |Size: |0: |Category: |Brand:"),
                              "");
                          g.trim();
                          var l = g.split(',');
                          print("s" + l.toString());
                          if (!(l[0] == "0")) {
                            return SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(1, 0),
                                  end: Offset(0, 0),
                                ).animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.ease,
                                    reverseCurve: Curves.ease)),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color.fromRGBO(0, 0, 0,
                                                      0.05000000074505806),
                                                  offset: Offset(0, 20),
                                                  blurRadius: 35)
                                            ],
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                          ),
                                          child: Stack(children: <Widget>[
                                            Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Container(
                                                  decoration: BoxDecoration(),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 0,
                                                                vertical: 0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          0,
                                                                      vertical:
                                                                          0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    l[1], //Product name
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            32,
                                                                            26,
                                                                            37,
                                                                            1),
                                                                        fontSize:
                                                                            20,
                                                                        letterSpacing:
                                                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        height:
                                                                            0.9),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          10),
                                                                  Text(
                                                                    l[3], //Product Size
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                    style: TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            195,
                                                                            198,
                                                                            201,
                                                                            1),
                                                                        fontSize:
                                                                            16,
                                                                        letterSpacing:
                                                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        height:
                                                                            1.1538461538461537),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  decoration: BoxDecoration(),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Text(
                                                        l[4], //Product Price
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    32,
                                                                    26,
                                                                    37,
                                                                    1),
                                                            fontFamily:
                                                                'Mulish',
                                                            fontSize: 20,
                                                            letterSpacing:
                                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            height:
                                                                0.8181818181818182),
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        'ريال',
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    91,
                                                                    90,
                                                                    91,
                                                                    1),
                                                            fontSize: 15,
                                                            letterSpacing:
                                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            height: 1.2),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ])),
                                    )));
                          }
                          return Container();
                        });
                  }
                  return Container(); //If not there is no LastCartNumber
                }),
          ),
        ],
      ),
    );
  }

  Widget Con() {
    if (numOfProducts == 0 && ConnectedToCart == true) {
      return CartEmpty();
    } else if (ConnectedToCart == true) {
      return Cart();
    }
    return Container();
  }

  Widget CartEmpty() {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/empty.png'),
                  fit: BoxFit.fitWidth),
            ),
          ),
          Container(
            child: Text(
              'سلة التسوق فارغة',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromARGB(219, 100, 98, 98),
                  fontFamily: 'CartToGo',
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void deactivate() {
    _streamSubscription.cancel();
    _streamSubscription1.cancel();
    super.deactivate();
  }
}
