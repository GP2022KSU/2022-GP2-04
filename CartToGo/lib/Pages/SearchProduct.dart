import 'package:carttogo/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

//لاني اندرويد مايطلع نتيجة باقي احد يتأكد انه يبحث

class NameSearch extends SearchDelegate<String> {
  final List<String> names;
// OLD >> NameSearch(this.names);

  //NEW with hint
  NameSearch(this.names)
      : super(
    searchFieldLabel: "     ابحث عن موقع المنتجات         ", // سويت كذا لان مالقيت شيء يخليه يجي يمين عند ايكون السيرش
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.search,
  );

  @override
  List<Widget>? buildActions(BuildContext context) { // حتى يرجع لشكل الصفحة الاساسي بدون كيبورد وكذا
    //right side of search bar
    return [
      IconButton(
          icon: Icon(
            Icons.arrow_forward_ios_outlined,
            color: appColor,
          ),
          onPressed: () {
            close(context, "");
          }

        /* onPressed: () {
          final result = showSearch<String>(
            context: context,
            delegate: NameSearch(names),
          );
          print(result);
        },*/
        //close(context,  result);
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) { // حتى يمسح الكلام اللي كتبه على السيرش بار يضغط الاكس
    //left side of search bar
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

  @override
  Widget buildResults(BuildContext context) {// لما يضغط المتسوق على النتيجة راح تطلع له بالنص
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
  @override
  Widget buildSuggestions(BuildContext context) {

    /*final ref = FirebaseDatabase.instance.ref();
    var BARCODE = query.isEmpty
        ? Center(
        child: Text(
          "لا توجد منتجات بهذا الإسم",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'CartToGo',
              fontSize: 18),
        )):
    ref.child("Products/").get();
     var LOCATION = query.isEmpty
        ? Center(
        child: Text(
          "لا توجد منتجات بهذا الإسم",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'CartToGo',
              fontSize: 18),
        )):
    ref.child("Products/BARCODE/query.Location").get();
     String LLOCATION = LOCATION.toString();*/

    final Suggestions = query.isEmpty
        ? names
        : names.where((p)=> p.startsWith(query)).toList();// maybe we will remove it

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

        onTap: () {// maybe we will remove it
          showResults(context);
        },

        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(10),
        ),

        trailing:
        Icon(Icons.location_on_outlined,
          color: appColor,
        ),

        title:
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            RichText(
                text: TextSpan(
                    text: Suggestions.elementAt(index).substring(0,query.length),
                    style:
                    TextStyle( color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'CartToGo',
                    ),
                    children: [TextSpan(
                      text: Suggestions.elementAt(index).substring(query.length),
                      style:
                      TextStyle( color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'CartToGo',
                      ),

                    )]
                )
            ),
            RichText(
                text: TextSpan(
                    text: Suggestions.elementAt(index+1).substring(0,query.length),
                    style:
                    TextStyle( color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'CartToGo',
                    ),
                    children: [TextSpan(
                      text: Suggestions.elementAt(index+1).substring(query.length),
                      style:
                      TextStyle( color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'CartToGo',
                      ),
                    )]
                )
            ),
            Divider() // to arrange them and make it comfortable to eye
          ],
        ),
      ),
    );
  }
}


/*
title:
          Text(
            Suggestions.elementAt(index),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'CartToGo',
            ),
            textAlign: TextAlign.right,
          ),

          subtitle :Text(
            Suggestions.elementAt(index+1),
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontFamily: 'CartToGo',
            ),
            textAlign: TextAlign.right,
          ),
 */