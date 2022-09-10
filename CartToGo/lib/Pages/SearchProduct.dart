import 'package:flutter/material.dart';
//import 'Product.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:carttogo/Pages/SeachProductList.dart';

//
//باقي
//
//

class NameSearch extends SearchDelegate<String> {

final List<String> names;

NameSearch(this.names);

  @override
  List<Widget>? buildActions(BuildContext context) {
    //right
    return [
    IconButton(
      icon: Icon(
        Icons.search,
        //color: appColor,
      ),
      onPressed: () {
        final result =  showSearch<String>(
          context: context,
          delegate: NameSearch(names),
        );
        print(result);
      },
      //  close(context,  result);
    ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    //left
    //var result;
    return  IconButton(
      icon: Icon(
        Icons.clear,
        //color: appColor,
      ),
      onPressed: () {
        query = '';
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) { // based in input
    final Suggestions = names.where((name){
      return name.toLowerCase().contains((query.toLowerCase()));
    });
    return ListView.builder(
      itemCount: Suggestions.length,
      itemBuilder: (BuildContext context, int index){
        return ListTile(
          title: Text(Suggestions.elementAt(index),
            style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'CartToGo',
          ),
          textAlign: TextAlign.right,
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
  final Suggestions = names.where((name){
  return name.toLowerCase().contains((query.toLowerCase()));
});
  return ListView.builder(
    itemCount: Suggestions.length,
      itemBuilder: (BuildContext context, int index){
        return ListTile(
          title: Text(Suggestions.elementAt(index),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'CartToGo',
            ),
            textAlign: TextAlign.right,
          ),
        );
      },
  );
  }
}
