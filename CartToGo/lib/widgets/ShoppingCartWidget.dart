// ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:carttogo/Pages/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:carttogo/Users/user.dart' as user;
import 'package:carttogo/Users/Products.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_scrolling_fab_animated/flutter_scrolling_fab_animated.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShoppingCartWidget extends StatefulWidget {
  const ShoppingCartWidget({Key? key}) : super(key: key);
  @override
  State<ShoppingCartWidget> createState() => ShoppingCartWidgetState();
}

class ShoppingCartWidgetState extends State<ShoppingCartWidget> {
  ScrollController _scrollController = ScrollController();
  double indicator = 10.0;
  bool onTop = true;
  late double total = 0.0;
  late int numOfProducts = 0;
  double totalCart = 0;
  late int LastCartNumber = 0;
  late bool ConnectedToCart = false;
  late bool checkDelete;
  final _fb = FirebaseDatabase.instance;
  final _database = FirebaseDatabase.instance.ref();
  late StreamSubscription _streamSubscription;
  late StreamSubscription _streamSubscription1;
  late StreamSubscription _streamSubscription2;
  late bool _isLoading;
  @override
  void initState() {
    _isLoading = true;

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });

    super.initState();
    _activateListeners();
    _CheckLastnumOfProd();
    _getTotal();
  }

  void _activateListeners() {
    if (FirebaseAuth.instance.currentUser != null) {
      _streamSubscription = _database
          .child(
              "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/ConnectedToCart")
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
  }

  Future<int> _CheckLastnumOfProd() async {
    if (FirebaseAuth.instance.currentUser != null) {
      _streamSubscription1 = _database
          .child(
              "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/NumOfProducts")
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
    return numOfProducts;
  }

  Future<double> _getTotal() async {
    if (FirebaseAuth.instance.currentUser != null) {
      _streamSubscription2 = _database
          .child(
              "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/Total")
          .onValue
          .listen((event) {
        final data = event.snapshot.value;
        setState(() {
          double hea = double.parse(data.toString());
          total = (double.parse(hea.toStringAsFixed(2)));
        });
      });
      print("total: $total");
      return total;
    }
    return total;
  }

  Future<int> BringLastCartNumber() async {
    if (FirebaseAuth.instance.currentUser != null) {
      _streamSubscription1 = _database
          .child(
              "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/FutureCartNumber")
          .onValue
          .listen((event) {
        final data = event.snapshot.value;
        LastCartNumber = (int.parse(data.toString())) - 1;
      });
      return LastCartNumber;
    }
    return LastCartNumber;
  }

  Future<int> BringProductQuantity(String barcode) async {
    int quan = 0;
      _streamSubscription1 =
          _database.child("Products/$barcode/Quantity").onValue.listen((event) {
        final data = event.snapshot.value;
        quan = (int.parse(data.toString()));
      });
      return quan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            ConnectedToCart == true && numOfProducts != 0 && _isLoading == false
                ? Center(
                    heightFactor: 3,
                    child: ScrollingFabAnimated(
                      width: MediaQuery.of(context).size.width * 0.9,
                      icon: Text(
                        "${total.toString()} ريال ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                        textDirection: TextDirection.rtl,
                      ),
                      text: Text(
                        '   الإجمالي:',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                        textDirection: TextDirection.rtl,
                      ),
                      onPress: () {},
                      scrollController: _scrollController,
                      animateIcon: false,
                      inverted: false,
                      radius: 10.0,
                    ))
                : Container(),
        body: _isLoading
            ? Center(
                child: SpinKitWave(
                color: Color.fromARGB(255, 35, 61, 255),
              ))
            : Con());
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
                      numOfProducts = user.getnumOfProducts();
                      var v = snapshot.value.toString();
                      var g = v.replaceAll(
                          RegExp(
                              "{|}|Name: |Price: |Size: |0: |Category: |Brand: |Barcode: | "),
                          "");
                      g.trim();
                      //g.replaceAll(from, replace)
                      var l = g.split(',');

                      print("s" + l.toString());
                      if (!(l[0] == "0")) {
                        void deleteProduct() async {
                          final Carts = _fb.ref().child(
                              "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts");
                          double price =
                              double.parse(l[2]); //price for IOS 4 android 2
                          total = total - price;
                          numOfProducts--;
                          await Carts.update({
                            'Total': total,
                            'numOfProducts': numOfProducts,
                          });
                          String barcode = l[3].toString();
                                                barcode.replaceAll(' ', "");
                          print("Barcode:$barcode");
                          final barcodePath =
                              _fb.ref().child("Products/$barcode");
                              int newQuantity = await BringProductQuantity(barcode) + 1;
                              print("Quan: $newQuantity");
                            
                              //_database.child("Products").child("$barcode").set(2);
                          await barcodePath.update({
                            'Quantity': newQuantity,
                          });
                          ref.child(snapshot.key!).remove();
                          await Carts.update({
                            'DeletingProduct': true,
                          });
                          Future.delayed(const Duration(milliseconds: 500),
                              () async {
                            await Carts.update({
                              'DeletingProduct': false,
                            });
                          });
                          print("Total after $total numOfProducts");
                        }

                        void _showMyDialog(BuildContext context) async {
                          return showDialog<void>(
                              context: context,
                              // user must tap button!
                              builder: (BuildContext context) {
                                return Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Dialog(
                                      elevation: 0,
                                      backgroundColor: Color(0xffffffff),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: 15),
                                          Text(
                                            "حذف المنتج",
                                            style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Text(
                                            "هل تريد حذف${l[1]} ؟", //Product name for IOS 1 android 4
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Divider(
                                            height: 1,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 50,
                                            child: InkWell(
                                              highlightColor: Colors.grey[200],
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                deleteProduct();
                                              },
                                              child: Center(
                                                child: Text(
                                                  "حذف",
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Color(0xFFFE4A49),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 1,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 50,
                                            child: InkWell(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(15.0),
                                                bottomRight:
                                                    Radius.circular(15.0),
                                              ),
                                              highlightColor: Colors.grey[200],
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Center(
                                                child: Text(
                                                  "إلغاء",
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                              });
                        }

                        return SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(1, 0),
                              end: Offset(0, 0),
                            ).animate(CurvedAnimation(
                                parent: animation,
                                curve: Curves.ease,
                                reverseCurve: Curves.ease)),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color.fromRGBO(
                                                  0, 0, 0, 0.05000000074505806),
                                              offset: Offset(0, 20),
                                              blurRadius: 35)
                                        ],
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                      child: Slidable(
                                          key: ValueKey(numOfProducts),
                                          closeOnScroll: false,
                                          endActionPane: ActionPane(
                                              motion: ScrollMotion(),
                                              children: [
                                                SlidableAction(
                                                  onPressed: _showMyDialog,
                                                  backgroundColor:
                                                      Color(0xFFFE4A49),
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.delete,
                                                  label: 'حذف المنتج',
                                                ),
                                              ]),
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
                                                                    l[0], //Product name 0 android 1 ios
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
                                                                    l[4], //Product Size 4 android 2 ios
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
                                                        l[2], //Product Price 2 android
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    32,
                                                                    26,
                                                                    37,
                                                                    1),
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
                                          ])))),
                            ));
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

  Widget Con() {
    if (ConnectedToCart == true && numOfProducts != 0 && _isLoading == false) {
      return Cart();
    } else if (numOfProducts == 0 &&
        ConnectedToCart == true &&
        _isLoading == false) {
      return CartEmpty();
    } else {
      return Container();
    }
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
          Text(
            'سلة التسوق فارغة',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromARGB(219, 100, 98, 98),
                fontFamily: 'CartToGo',
                fontSize: 26,
                fontWeight: FontWeight.w800,
                height: 1),
          ),
        ],
      ),
    );
  }

  @override
  void deactivate() {
    _streamSubscription.cancel();
    _streamSubscription1.cancel();
    _streamSubscription2.cancel();
    super.deactivate();
  }
}
