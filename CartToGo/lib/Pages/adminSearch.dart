import 'package:carttogo/main.dart';
import 'package:flutter/material.dart';

import '../scanner_icons.dart';
import 'addNewProduct.dart';

class AdminSearch extends SearchDelegate<String> {
  final List<String> names;

  AdminSearch(this.names)
      : super(
          searchFieldLabel: "  ابحث عن منتج لحذفه أو تعديله  ",
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  List<Widget>? buildActions(BuildContext context) {
    // حتى يرجع لشكل الصفحة الاساسي بدون كيبورد وكذا
    //right side of search bar
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

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const scanProductBarcode(),
        ));
      },
      icon: const Icon(Scanner.scanner),
      color: appColor,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // لما يضغط المتسوق على النتيجة راح تطلع له بالنص
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

//ميثود لظهور الاقتراحات عند البحث
  @override
  Widget buildSuggestions(BuildContext context) {
    final Suggestions = query.isEmpty
        ? names
        : names.where((p) => p.startsWith(query)).toList();

    return Suggestions.isEmpty && query.isNotEmpty
        ? Center(
            child: Text(
            "لا توجد منتجات بهذا الإسم",
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
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  RichText(
                      text: TextSpan(
                          text: Suggestions.elementAt(index)
                              .substring(0, query.length),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CartToGo',
                          ),
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
                  Divider() // to arrange them and make it comfortable to eye
                ],
              ),
            ),
          );
  }
}
