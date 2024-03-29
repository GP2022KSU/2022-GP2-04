// ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_const_literals_to_create_immutables, nullable_type_in_catch_clause
import 'dart:async';
import 'package:carttogo/Pages/Shopper/checkOut.dart';
import 'package:carttogo/Pages/Shopper/shoppingCart.dart';
import 'package:carttogo/Pages/Cashier/Cashier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:carttogo/Users/user.dart' as user;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_scrolling_fab_animated/flutter_scrolling_fab_animated.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carttogo/main.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ShoppingCartWidget extends StatefulWidget {
  const ShoppingCartWidget({Key? key}) : super(key: key);
  @override
  State<ShoppingCartWidget> createState() => ShoppingCartWidgetState();
}

class ShoppingCartWidgetState extends State<ShoppingCartWidget> {
  ScrollController _scrollController = ScrollController();
  late double total = 0.0;
  late int numOfProducts = 0;
  double totalCart = 0;
  late int LastCartNumber = 0;
  late bool ConnectedToCart = false;
  late bool ShowNotRegisteredProduct = false;
  late bool checkDelete;
  final _fb = FirebaseDatabase.instance;
  final _database = FirebaseDatabase.instance.ref();
  late StreamSubscription _streamSubscription;
  late StreamSubscription _streamSubscription1;
  late StreamSubscription _streamSubscription2;
  late double TotalInCart = 0;
  late bool _isLoading;
  late Timer _timer;
  late Timer _timerinactivity;
  bool checkTimer = false;
  int checkAlertCount = 0;
  @override
  void initState() {
    _isLoading = true;
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _timerinactivity =
              Timer(const Duration(seconds: 30), () => _handleInactivity());
          _isLoading = false;
          /*
          _streamSubscription1 = _database
              .child(
                  "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/${user.getLastCartNum()}/Total")
              .onValue
              .listen((event) {
            final data = event.snapshot.value;
            setState(() {
              TotalInCart = double.parse(event.snapshot.value.toString());
            });
            
          });
          */
        });
      }
    });

    _activateListeners();
    _CheckLastnumOfProd();
    _getTotal();
  }

  void _handleInactivity() async {
    _timerinactivity.cancel();
    // if (checkTimer) {
    //   print("Inactive");
    //   DatabaseReference ref2 = FirebaseDatabase.instance.ref(
    //       "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/CartsStatus");
    //   await ref2.update({
    //     "ConnectedToCart": false,
    //     "Total": 0,
    //     "NumOfProducts": 0,
    //     "TotalAfterPoints": 0,
    //   });
    //   setState(() {
    //     checkTimer = false;
    //   });
    // }
  }

//-----------Listens for ConnectedToCart to show the cart-----------//
  void _activateListeners() {
    /*
    _streamSubscription1 = _database
        .child(
            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/${user.getLastCartNum()}/Total")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      setState(() {
        TotalInCart = double.parse(event.snapshot.value.toString());
      });
    });
    */

    if (FirebaseAuth.instance.currentUser != null) {
      _streamSubscription = _database
          .child(
              "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/CartsStatus/ConnectedToCart")
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
    _streamSubscription = _database
        .child(
            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/CartsStatus/CheckAlert")
        .onValue
        .listen((event) {
      var snapshot = event.snapshot.value;
      if (checkAlertCount++ == 0 && snapshot == true) {
        if (checkAlertCount == 1) AlertShopperdisconnection(context);
      }
    });
  }

  /* //-----------For Future Code-----------//
  void _ShowNotRegisteredProduct() {
    if (FirebaseAuth.instance.currentUser != null) {
      _streamSubscription3 = _database
          .child(
              "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/ShowNotRegisteredProduct")
          .onValue
          .listen((event) {
        final data = event.snapshot.value;
        print("Data $data");
        String Fornow = "false";
        Fornow = data.toString();
        if (Fornow.toLowerCase() == 'true' && ConnectedToCart == true) {
          _showNotRegisteredProduct();
          Future.delayed(const Duration(milliseconds: 500), () async {
            final _fb = FirebaseDatabase.instance;
            final Carts = await _fb.ref().child(
                "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts");
            await Carts.update({
              'ShowNotRegisteredProduct': false,
            });
          });
        }
      });
    }
  }
  */
  //-----------Listens for Number of products-----------//
  Future<int> _CheckLastnumOfProd() async {
    if (FirebaseAuth.instance.currentUser != null) {
      _streamSubscription1 = _database
          .child(
              "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/CartsStatus/NumOfProducts")
          .onValue
          .listen((event) {
        final data = event.snapshot.value;
        setState(() {
          numOfProducts = (int.parse(data.toString()));
        });
      });
      return numOfProducts;
    }
    return numOfProducts;
  }

  //-----------Listens for Total to show the total price-----------//
  Future<double> _getTotal() async {
    if (FirebaseAuth.instance.currentUser != null) {
      _streamSubscription2 = _database
          .child(
              "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/CartsStatus/Total")
          .onValue
          .listen((event) {
        final data = event.snapshot.value;
        setState(() {
          double hea = double.parse(data.toString());
          total = (double.parse(hea.toStringAsFixed(2)));
        });
      });
      return total;
    }
    return total;
  }

  //-----------Listens for FutureCartNumber to show newest cart-----------//
  Future<int> BringLastCartNumber() async {
    if (FirebaseAuth.instance.currentUser != null) {
      _streamSubscription = _database
          .child(
              "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/CartsStatus/FutureCartNumber")
          .onValue
          .listen((event) {
        final data = event.snapshot.value;
        LastCartNumber = (int.parse(data.toString())) - 1;
      });
      return LastCartNumber;
    }
    return LastCartNumber;
  }

  //-----------Brings the quantity of the deleted product-----------//
  Future<int> BringProductQuantity(int barcode) async {
    final _quanData = FirebaseDatabase.instance
        .ref("Products/${barcode.toString()}/Quantity");
    final snapshot = await _quanData.get();
    if (snapshot.exists) {
      return (int.parse(snapshot.value.toString()));
    } else {}
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ConnectedToCart == true &&
                numOfProducts != 0 &&
                _isLoading == false
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
                    '  اتمام الدفع' + "  (" + numOfProducts.toString() + ")",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                    textDirection: TextDirection.rtl,
                  ),
                  onPress: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CheckOut()));
                  },
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
                      final map = snapshot.value as Map<dynamic, dynamic>;
                      ;
                      var v = snapshot.value
                          .toString(); //Gets the scanned product and store it in a var
                      bool checker = true;
                      String Brand = "";
                      String Name = "";
                      String Size = "";
                      double Price = 0;
                      String Barcode = "";
                      bool HaveOffer = false;
                      double PriceAfterOffer = 0;
                      bool Noimg = true;
                      String imgUrl = '';
                      int spaceForImage = 0;

                      //So the list does not read the cart's info only products
                      if (map["Paid"] == null) {
                        //if there is data
                        try {
                          if (map['ImgUrl'] == "") {
                            spaceForImage = 0;
                            Noimg = true;
                          } else {
                            spaceForImage = 20;
                            Noimg = false;
                            imgUrl = map['ImgUrl'];
                          }
                          Name = map['Name'];
                          Size = map['Size'];
                          Brand = map['Brand'];
                          Price = double.parse(map['Price'].toString());
                          Barcode = map['Barcode'];
                          PriceAfterOffer =
                              double.parse(map['PriceAfterOffer'].toString());
                          HaveOffer = map['Offer'];
                        } on Exception {
                          checker = false;
                        }
                        //-----------Deletes the swiped product-----------//
                        void deleteProduct(var product) async {
                          final Carts = _fb.ref().child(
                              "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/CartsStatus");
                          double price;
                          if (HaveOffer) {
                            price = PriceAfterOffer; //price for IOS 5 android 2
                          } else {
                            price = Price;
                          }
                          total = total - price;
                          numOfProducts--;
                          await Carts.update({
                            'Total': (double.parse(total.toStringAsFixed(2))),
                            'NumOfProducts': numOfProducts,
                          });
                          int barcode =
                              (int.parse(Barcode)); //barcode android 3 , IOS 0
                          int newQuantity =
                              await BringProductQuantity(barcode) + 1;
                          if (FirebaseAuth.instance.currentUser != null) {
                            final quannn = _fb
                                .ref()
                                .child("Products/${barcode.toString()}");
                            await quannn.update({
                              "Quantity": newQuantity,
                            });
                          }
                          product.remove();
                          await Carts.update({
                            'DeletingProduct': true,
                          });
                          Future.delayed(const Duration(milliseconds: 8000),
                              () async {
                            await Carts.update({
                              'DeletingProduct': false,
                            });
                          });
                        }
                        //-----------Removes the product from the shopping cart and put it in wishlist-----------//

                        void addToWishList(
                            var product, BuildContext context) async {
                          final Carts = _fb.ref().child(
                              "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/CartsStatus");
                          double price;
                          if (HaveOffer) {
                            price = PriceAfterOffer; //price for IOS 5 android 2
                          } else {
                            price = Price;
                          }
                          total = total - price;
                          numOfProducts--;
                          await Carts.update({
                            'Total': (double.parse(total.toStringAsFixed(2))),
                            'NumOfProducts': numOfProducts,
                          });
                          int barcode =
                              (int.parse(Barcode)); //barcode android 3 , IOS 0
                          int newQuantity =
                              await BringProductQuantity(barcode) + 1;
                          if (FirebaseAuth.instance.currentUser != null) {
                            final quannn = _fb
                                .ref()
                                .child("Products/${barcode.toString()}");
                            await quannn.update({
                              "Quantity": newQuantity,
                            });
                          }

                          final WishList = _fb.ref().child(
                              "Shopper/${FirebaseAuth.instance.currentUser?.uid}/WishList");

                          await WishList.push().update({
                            "Barcode": barcode,
                            "Name": Name,
                            "Brand": Brand,
                            "ImgUrl": imgUrl,
                            "Category": map['Category'],
                            "Offer": map['Offer'] == true ? true : false,
                            "Price": Price,
                            "PriceAfterOffer": PriceAfterOffer,
                            "Size": Size,
                            "SubCategory": map['SubCategory']
                          });

                          product.remove();
                          await Carts.update({
                            'DeletingProduct': true,
                          });
                          Future.delayed(const Duration(milliseconds: 8000),
                              () async {
                            await Carts.update({
                              'DeletingProduct': false,
                            });
                          });
                        }

                        //-----------To confirm the deleted items-----------//

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
                                            "هل تريد حذف ${Name + " " + Brand} ؟", //Product name for IOS 4 android 1
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
                                                deleteProduct(
                                                    ref.child(snapshot.key!));
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

                        //-----------Returns list of the scanned products-----------//
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
                                                  label: 'حذف',
                                                ),
                                                SlidableAction(
                                                  onPressed: (context) {
                                                    showThatAppeardInWishList();

                                                    addToWishList(
                                                        (ref.child(
                                                            snapshot.key!)),
                                                        context);
                                                  },
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 35, 61, 255),
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.favorite,
                                                  label: "الأمنيات",
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
                                                            Noimg == true
                                                                ? Container()
                                                                : Image.network(
                                                                    imgUrl),
                                                            SizedBox(
                                                                width: double.parse(
                                                                    spaceForImage
                                                                        .toString())),
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.5,
                                                              decoration:
                                                                  BoxDecoration(),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          2,
                                                                      vertical:
                                                                          2),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: <
                                                                    Widget>[
                                                                  AutoSizeText(
                                                                    Name +
                                                                        " - " +
                                                                        Brand, //Product name 1 android 4 ios
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
                                                                            16,
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
                                                                    Size, //Product Size 4 android 0 ios
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
                                            HaveOffer
                                                ? AfterOffer(
                                                    Price, PriceAfterOffer)
                                                : Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Container(
                                                      decoration:
                                                          BoxDecoration(),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          Text(
                                                            Price
                                                                .toString(), //Product Price 2 android ios 5
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(32,
                                                                        26, 37, 1),
                                                                fontSize: 20,
                                                                letterSpacing:
                                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                height:
                                                                    0.8181818181818182),
                                                          ),
                                                          SizedBox(width: 4),
                                                          Text(
                                                            'ريال',
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(91,
                                                                        90, 91, 1),
                                                                fontSize: 15,
                                                                letterSpacing:
                                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
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

  Widget AfterOffer(double PriceBefore, double PriceAfter) {
    return Align(
      alignment: Alignment.centerLeft,
      //padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(),
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              PriceBefore.toString(), //Product Price 2 android ios 5
              textAlign: TextAlign.center,
              style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Color.fromRGBO(91, 90, 91, 1),
                  fontSize: 20,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.w700,
                  height: 0.8181818181818182),
            ),
            SizedBox(height: 10),
            Text(
              PriceAfter.toString(), //Product Price 2 android ios 5
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(32, 26, 37, 1),
                  fontSize: 20,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.w700,
                  height: 0.8181818181818182),
            ),
            SizedBox(width: 4),
            Text(
              'ريال',
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Color.fromRGBO(91, 90, 91, 1),
                  fontSize: 15,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.w600,
                  height: 1.2),
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
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

  Widget SlidingUp() {
    return SlidingUpPanel(
      parallaxEnabled: true,
      parallaxOffset: 2,
      maxHeight: 700,
      minHeight: 200,
      body: Cart(),
      //panelBuilder: (_) => CheckOut(),
      //collapsed: ,
    );
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

  Object showThatAppeardInWishList() {
    if (true) {
      return showDialog<void>(
          context: context,
          // user must tap button!
          builder: (BuildContext context) {
            _timer = Timer(const Duration(milliseconds: 1750), () {
              Navigator.of(context).pop(); // == First dialog closed
            });
            return Directionality(
                textDirection: TextDirection.rtl,
                child: Dialog(
                  elevation: 0,
                  backgroundColor: const Color(0xffffffff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      SizedBox(height: 15),
                      Text(
                        "تمت اضافة المنتج لقائمة الامنيات",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ));
          }).then((val) {
        if (_timer.isActive) {
          _timer.cancel();
        }
      });
    }
  }

  void AlertShopperdisconnection(BuildContext context) async {
    return showDialog<void>(
        context: context,
        // user must tap button!
        builder: (BuildContext context) {
          _timer = Timer(const Duration(seconds: 20), () async {
            setState(() {
              checkAlertCount = 0;
            });
            DatabaseReference ref2 = FirebaseDatabase.instance.ref(
                "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/CartsStatus");
            await ref2.update({
              "CheckAlert": false,
              "ConnectedToCart": false,
              "Total": 0,
              "NumOfProducts": 0,
              "TotalAfterPoints": 0,
            });
            Navigator.of(context).pop(); // == First dialog closed
          });
          return Directionality(
              textDirection: TextDirection.rtl,
              child: Dialog(
                elevation: 0,
                backgroundColor: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      "تنبيه",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "سيتم الغاء الاتصال بالسلة في حال لم تقم باضافة اي منتج جديد خلال 5 دقايق", //Product name for IOS 4 android 1
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
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: InkWell(
                        highlightColor: Colors.grey[200],
                        onTap: () async {
                          DatabaseReference ref2 = FirebaseDatabase.instance.ref(
                              "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/CartsStatus");
                          await ref2.update({"CheckAlert": false});
                          setState(() {
                            checkAlertCount = 0;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Center(
                          child: Text(
                            "نعم",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Color.fromARGB(255, 4, 238, 101),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                    ),
                  ],
                ),
              ));
        }).then((val) async {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }

  /* //-----------For future code-----------//
  void _showNotRegisteredProduct() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        // user must tap button!
        builder: (BuildContext context) {
          return Directionality(
              textDirection: TextDirection.rtl,
              child: Dialog(
                elevation: 0,
                backgroundColor: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      "حدث خطأ",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "المنتج غير مسجل", //Product name for IOS 1 android 4
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(
                      height: 2,
                      color: Colors.black,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: InkWell(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15.0),
                          bottomRight: Radius.circular(15.0),
                        ),
                        highlightColor: Colors.grey[200],
                        onTap: () async {
                          final _fb = FirebaseDatabase.instance;
                          final Carts = await _fb.ref().child(
                              "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts");
                          await Carts.update({
                            'ShowNotRegisteredProduct': false,
                          });

                          Navigator.of(context).pop();
                        },
                        child: Center(
                          child: Text(
                            "موافق",
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: appColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
  */
  @override
  void deactivate() {
    super.deactivate();
    _streamSubscription.cancel();
  }
}
