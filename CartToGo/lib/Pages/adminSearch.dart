import 'package:carttogo/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'productsListAdmin.dart';

class AdminSearch extends SearchDelegate<String> {
  final List<String> barcodes;
  var splitted;
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

  // to delete what in the search bar  
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

// when the admin chooses a product, the result will be centered on the screen
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
                showResults(context);
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
                      tooltip: "حذف المنتج",
                      icon: Icon(
                        Icons.delete,
                        color: Color.fromARGB(255, 255, 0, 0),
                      ),
                      onPressed: () {
                       var splitted =
                             Suggestions.elementAt(index).split(" | ");
                         print(splitted[1]);
                         //_DeleteOrNot(splitted[1].toString());
                         _DeleteOrNot(splitted[1].toString(), context);
                         //Suggestions.removeAt(index); //عشان يشيل من اللست ما ضبط
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
                    SizedBox(
                      width: 10,
                    ),
                    Divider() // to arrange the products list
                  ]),
            ),
          );
  }

  void _DeleteOrNot(String barcode, BuildContext context) async {
    final ref = fb.ref().child('Products/${barcode}');
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
