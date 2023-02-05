import 'dart:async';

import 'package:carttogo/main.dart';
import 'package:flutter/material.dart';
import 'package:carttogo/Pages/welcomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carttogo/widgets/shoppingListItem.dart';
import 'package:carttogo/Componentss/item.dart';
import 'package:carttogo/Componentss/WishListItems.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:carttogo/Users/user.dart' as user;

class Lists extends StatefulWidget {
  @override
  State<Lists> createState() => _ListsState();
}

class _ListsState extends State<Lists> with SingleTickerProviderStateMixin {
  @override
  //final ShoppingList = ShoppingItem.shoppingList();
  late Timer _timer;
  final _newProductController = TextEditingController();
  late TabController _tabController;
  final refShoppingList = FirebaseDatabase.instance
      .ref("Shopper/${FirebaseAuth.instance.currentUser?.uid}/ShoppingList");
  final refWishList = FirebaseDatabase.instance
      .ref("Shopper/${FirebaseAuth.instance.currentUser?.uid}/WishList");
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white24,
        title: const Text(
          "القوائم",
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
                  _showMyDialog();
                },
                child: const Text('خروج')),
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(
                  15.0,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    15.0,
                  ),
                  color: appColor,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.list_outlined),
                    text: 'قائمة التسوق',
                  ),
                  Tab(
                    icon: Icon(Icons.favorite),
                    text: 'قائمة الأمنيات',
                  ),
                ],
              ),
            ),

            // Tab views inside the TabBar
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: FirebaseAnimatedList(
                                    query: refShoppingList,
                                    duration: const Duration(milliseconds: 500),
                                    itemBuilder: (BuildContext context,
                                        DataSnapshot snapshot,
                                        Animation<double> animation,
                                        int index) {
                                      print(_tabController);
                                      final items = snapshot.value
                                          as Map<dynamic, dynamic>;
                                      final item = ShoppingItem.fromMap(items);
                                      return Column(children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                        ),
                                        shoppingListItem(
                                          item: item,
                                          onItemChanged: _handleItemChange,
                                          onDeleteItem: _deleteItem,
                                        ),
                                      ]);
                                    }))
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(
                                bottom: 85,
                                right: 20,
                                left: 20,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 10.0,
                                    spreadRadius: 0.0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: _newProductController,
                                decoration: const InputDecoration(
                                    hintText: 'اضف منتج جديد',
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              bottom: 85,
                              right: 20,
                            ),
                            child: ElevatedButton(
                              child: const Text(
                                '+',
                                style: TextStyle(
                                  fontSize: 40,
                                ),
                              ),
                              onPressed: () {
                                _addItem(_newProductController.text);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: appColor,
                                minimumSize: const Size(60, 60),
                                elevation: 10,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),

                  // WishList tab view
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.69,
                            child: FirebaseAnimatedList(
                                query: refWishList,
                                duration: const Duration(milliseconds: 500),
                                itemBuilder: (BuildContext context,
                                    DataSnapshot snapshot,
                                    Animation<double> animation,
                                    int index) {
                                  if (snapshot != null) {
                                    final items =
                                        snapshot.value as Map<dynamic, dynamic>;
                                    final wishItem = WishProduct.fromMap(items);
                                    return Column(children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 11,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 5),
                                        child: ListTile(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 5),
                                          tileColor: Colors.white,
                                          trailing: Image.network(
                                            wishItem.ImgUrl,
                                            fit: BoxFit.contain,
                                            width: 50,
                                            height: 60,
                                          ),
                                          title: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            padding: const EdgeInsets.all(0),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Text(
                                                wishItem.Name +
                                                    " " +
                                                    wishItem.Brand,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          leading: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12),
                                                height: 60,
                                                width: 35,
                                                child: IconButton(
                                                  color: appColor,
                                                  iconSize: 20,
                                                  icon: const Icon(
                                                      Icons.shopping_cart),
                                                  onPressed: () async {
                                                    // ignore: unrelated_type_equality_checks
                                                    await user.BringConnectedToCart() ==
                                                            true
                                                        ? showThatAppeardInShoppingList(
                                                            wishItem.Barcode,
                                                            snapshot.key
                                                                .toString(),
                                                            context)
                                                        : _showNotConnectedToCart(
                                                            context);
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              const Text(
                                                'ريال',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      91, 90, 91, 1),
                                                  fontSize: 15,
                                                  letterSpacing:
                                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                                  height: -2,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                wishItem.Offer == true
                                                    ? wishItem.PriceAfterOffer
                                                        .toString()
                                                    : wishItem.Price
                                                        .toString(), //Product Price 2 android ios 5
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        32, 26, 37, 1),
                                                    fontSize: 15,
                                                    letterSpacing:
                                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight: FontWeight.w600,
                                                    height: -2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]);
                                  }
                                  return Container();
                                }))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addToCart(String Barcode, String id, BuildContext context) async {
    final ref = FirebaseDatabase.instance.ref();
    final CartsInfo = await ref
        .child(
            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/CartsStatus")
        .get(); //brings the current cart info
    final CartsInfoMap = CartsInfo.value as Map<dynamic, dynamic>;

    final WishProduct productInfo = await user.BringProductInfo(
        Barcode); //bring the latest product update from the database
    print("Here" + productInfo.Barcode);
    //Modify Cart Total

    productInfo.Offer == true
        ? CartsInfoMap['Total'] =
            double.parse(CartsInfoMap['Total'].toString()) +
                productInfo.PriceAfterOffer
        : CartsInfoMap['Total'] =
            double.parse(CartsInfoMap['Total'].toString()) + productInfo.Price;

    //Modify Cart NumberOfitems

    CartsInfoMap['NumOfProducts'] =
        (int.parse(CartsInfoMap['NumOfProducts'].toString())) + 1;

    await ref
        .child(
            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/CartsStatus")
        .update({
      'Total': (double.parse(CartsInfoMap['Total'].toStringAsFixed(2))),
      'NumOfProducts': int.parse(CartsInfoMap['NumOfProducts'].toString()),
    });

    await ref
        .child(
            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/${await user.BringLastCartNumber()}")
        .push()
        .update({
      "Barcode": Barcode,
      "Brand": productInfo.Brand,
      "Category": productInfo.Category,
      "ImgUrl": productInfo.ImgUrl,
      "Name": productInfo.Name,
      "Offer": productInfo.Offer == true ? true : false,
      "Price": productInfo.Price,
      "PriceAfterOffer": productInfo.PriceAfterOffer,
      "Size": productInfo.Size,
      "SubCategory": productInfo.Subcategory
    });

    int barcode = (int.parse(Barcode));
    int newQuantity = await user.BringProductQuantity(barcode) + 1;
    if (FirebaseAuth.instance.currentUser != null) {
      final quannn = ref.child("Products/${barcode.toString()}");
      await quannn.update({
        "Quantity": newQuantity,
      });
    }

    refWishList.child(id).remove(); //remove from wishlist

    await ref
        .child(
            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/CartsStatus")
        .update({
      'DeletingProduct': true,
    });
    Future.delayed(const Duration(milliseconds: 8000), () async {
      await ref
          .child(
              "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/CartsStatus")
          .update({
        'DeletingProduct': false,
      });
    });
  }

  Object showThatAppeardInShoppingList(
      String Barcode, String id, BuildContext context) {
    addToCart(Barcode, id, context);
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
                        "تمت اضافة المنتج لسلة التسوق",
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

  void _showNotConnectedToCart(BuildContext context) async {
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
                      "لست متصل بالسلة",
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

//change from bought to donw
  void _handleItemChange(ShoppingItem item) {
    setState(() {
      if (item.isBuyed == false) {
        refShoppingList.child(item.id.toString()).update({"isBuyed": true});
      } else if (item.isBuyed == true) {
        refShoppingList.child(item.id.toString()).update({"isBuyed": false});
      }
      //item.isBuyed = !item.isBuyed;
    });
  }

//delete item from database ShoppingList
  void _deleteItem(String id) {
    setState(() {
      refShoppingList.child(id).remove();
    });
  }

  //add item to database ShoppingList
  void _addItem(String shoppingItem) {
    if (shoppingItem != "") {
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      setState(() {
        refShoppingList.update({
          id: {
            "ItemID": id,
            "productName": shoppingItem,
            "isBuyed": false,
          }
        });
      });
    }
    _newProductController.clear();
  }

  //logout dialog, to ensure that the shopper want to log out or not
  void _showMyDialog() async {
    return showDialog<void>(
        context: context,
        // user must tap button!
        builder: (BuildContext context) {
          return Directionality(
              textDirection: TextDirection.rtl,
              child: Dialog(
                  elevation: 0,
                  backgroundColor: const Color(0xffffffff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(height: 15),
                    const Text(
                      "هل تريد تسجيل الخروج؟",
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
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: InkWell(
                            highlightColor: Colors.grey[200],
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              print(
                                  "UID: ${FirebaseAuth.instance.currentUser?.uid}");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const WelcomePage()));
                            },
                            child: const Center(
                                child: Text("خروج",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Color(0xFFFE4A49),
                                      fontWeight: FontWeight.bold,
                                    ))))),
                    const Divider(
                      height: 1,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: InkWell(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0),
                            ),
                            highlightColor: Colors.grey[200],
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Center(
                                child: Text("إلغاء",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    )))))
                  ])));
        });
  }
}
