import 'package:carttogo/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:carttogo/Pages/Admin/updateProduct.dart';

class AdminSearch extends SearchDelegate<String> {
  final List<String> barcodes;
  var splitted;
  List<String> Locations = [
    'ممر 1',
    'ممر 2',
    'ممر 3',
    'ممر 4',
    'ممر 5',
    'ممر 6',
    'ممر 7',
    'ممر 8',
    'ممر 9',
    'ممر 10',
    'ممر 11',
    'ممر 12'
  ];
  bool isOffer = false;
  static bool ShowOfferPrice = false;

  late String selectedLocation; // to save the value of the new location
  final _formKey = GlobalKey<FormState>();

  final fb = FirebaseDatabase.instance;
  AdminSearch(this.barcodes)
      : super(
          searchFieldLabel: "  ابحث عن منتج لحذفه أو تعديله  ",
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

// to view the list without a keyboard
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(
            Icons.arrow_forward_ios_outlined,
            color: appColor,
          ),
          onPressed: () {
            close(context, "");
          }),
    ];
  }

  // to clear the search bar
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.cancel,
        color: appColor,
      ),
      onPressed: () {
        query = '';
      },
    );
  }

// when the admin chooses a product by clicking on it or tapping enter, the result will be centered on the screen
  @override
  Widget buildResults(BuildContext context) {
    return Center(
        child: Text(
      query,
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'CartToGo',
          fontSize: 18),
    ));
  }

// suggestions for products when searching for a product
  @override
  Widget buildSuggestions(BuildContext context) {
    final Suggestions = query.isEmpty
        ? barcodes
        : barcodes.where((p) => p.startsWith(query)).toList();
    return Suggestions.isEmpty && query.isNotEmpty
        ? Center(
            child: Text(
            "لا توجد منتجات بهذا الرمز الشريطي",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'CartToGo',
                fontSize: 18),
          ))
        : ListView.builder(
            itemCount: Suggestions.length,
            itemBuilder: (BuildContext context, int index) => ListTile(
              onTap: () {
                query = barcodes[index];
              },
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              title: Row(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      tooltip: "تعديل المنتج",
                      icon: Icon(
                        Icons.edit,
                        color: appColor,
                      ),
                      onPressed: () async {
                        var splitted =
                            Suggestions.elementAt(index).split(" | ");
                        DatabaseReference ref = FirebaseDatabase.instance
                            .ref("Products/${splitted[0].toString()}");
                        DatabaseEvent quan = await ref.child("Quantity").once();
                        DatabaseEvent price = await ref.child("Price").once();
                        DatabaseEvent location =
                            await ref.child("Location").once();
                        DatabaseEvent offer = await ref.child("Offer").once();
                        DatabaseEvent nprice =
                            await ref.child("PriceAfterOffer").once();

                        var QUANTITY =
                            int.parse(quan.snapshot.value.toString());
                        var PRICE =
                            double.parse(price.snapshot.value.toString());
                        var LOCATION = location.snapshot.value.toString();
                        var OFFER = offer.snapshot.value.toString();
                        var NEWPRICE =
                            double.parse(nprice.snapshot.value.toString());
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return UpdateProduct(splitted[0].toString(), QUANTITY,
                              PRICE, NEWPRICE, OFFER == true ? true : false,LOCATION);
                        }));
                      },
                    ),
                    IconButton(
                      tooltip: "حذف المنتج",
                      icon: Icon(
                        Icons.delete,
                        color: Color.fromARGB(255, 255, 0, 0),
                      ),
                      onPressed: () {
                        var splitted =
                            Suggestions.elementAt(index).split(" | ");
                        print(splitted[0]);
                        _DeleteOrNot(splitted[0].toString(), context);
                        barcodes.removeAt(index); //عشان يشيل من اللست ما ضبط
                      },
                    ),

                    // make the typing numbers bold
                    RichText(
                        text: TextSpan(
                            text: Suggestions.elementAt(index)
                                .substring(0, query.length),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CartToGo',
                            ),
                            // products list
                            children: [
                          TextSpan(
                            text: Suggestions.elementAt(index)
                                .substring(query.length),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'CartToGo',
                            ),
                          )
                        ])),
                    Divider() // to arrange the products list
                  ]),
            ),
          );
  }

  // delete a product from the database/stock choice
  void _DeleteOrNot(String barcode, BuildContext context) async {
    final ref = fb.ref().child('Products/$barcode');
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
              textDirection: TextDirection.rtl,
              child: Dialog(
                  elevation: 0,
                  backgroundColor: Color(0xffffffff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    SizedBox(height: 15),
                    Text(
                      "هل تريد حذف المنتج؟",
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
                            onTap: () async {
                              await ref.remove();
                              Navigator.of(context).pop();
                            },
                            child: Center(
                                child: Text("نعم",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Color(0xFFFE4A49),
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
                              bottomRight: Radius.circular(15.0),
                            ),
                            highlightColor: Colors.grey[200],
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Center(
                                child: Text("لا",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    )))))
                  ])));
        });
  }
}
