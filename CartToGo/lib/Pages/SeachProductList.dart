import 'package:carttogo/main.dart';
import 'package:flutter/material.dart';
import 'package:carttogo/Pages/locationSearch.dart';
import 'Product.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carttogo/Users/user.dart' as user;

class SearchProductList extends StatefulWidget {
  SearchProductList({Key? key}) : super(key: key);
  @override
  _SearchProductListState createState() => _SearchProductListState();
}

// List<String> names = []; // list contains all products' names

// getNames() async {
//   final snapshot = await FirebaseDatabase.instance.ref('Products').get();
//   final map = snapshot.value as Map<dynamic, dynamic>;
//   map.forEach((key, value) {
//     final product = Product.fromMap(value);
//     names.add(product.toString());
//   });
//   return names;
// }

class _SearchProductListState extends State<SearchProductList> {
  // to show the all the products names & locations before looking for something specific

 // اذا شلنا هذا تقل نتايج البحث وما تتكر كثير 
  // late bool _isLoading;

  // void initState() {
  //   _isLoading = true;
  //   Future.delayed(const Duration(milliseconds: 500), () {
  //     if (mounted) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   });
  //   user.getNames();
  //   super.initState();
  // }

  // search bar to seach for the pro's location
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "البحث عن المنتجات",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'CartToGo',
          ),
          textAlign: TextAlign.right,
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              final result = await showSearch<String>(
                context: context,
                delegate: LocationSearch(user.getNames()),
              );
            },
            icon: Icon(Icons.search_outlined),
            color: appColor,
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.79,
        child: ListView.builder(
          itemCount: user.getBarcode().length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(
                user.getNames().elementAt(index),
                style: TextStyle(
                  color: Colors.black,
                  backgroundColor: Color.fromARGB(255, 248, 248, 249),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'CartToGo',
                ),
                textAlign: TextAlign.right,
              ),
            );
          },
        ),
      ),
    );
  }
}
