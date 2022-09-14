import 'package:carttogo/main.dart';
import 'package:flutter/material.dart';
import 'package:carttogo/Pages/searchProduct.dart';
import 'Product.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carttogo/Users/user.dart' as user;


// باقي احد يتأكد انه يبحث
class Search2 extends StatefulWidget {
  Search2({Key? key}) : super(key: key);
  @override
  _Search2State createState() => _Search2State();
}

List<String> names = [];

getProducts() async {
  final snapshot = await FirebaseDatabase.instance.ref('Products').get();
  final map = snapshot.value as Map<dynamic, dynamic>;
  map.forEach((key, value) {
    final product = Product.fromMap(value);
    names.add(product.toString());
  });
  return names;
}

class _Search2State extends State<Search2> {
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
                delegate: NameSearch(user.getProducts()),
              );
              print(result);
            },
            icon: Icon(Icons.search_outlined),
            color: appColor,
          )
        ],
      ),

      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              names.elementAt(index),
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
    );
  }
}
