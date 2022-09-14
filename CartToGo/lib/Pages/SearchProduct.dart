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

  /* تجاهلوه بس كنت احاول اجيب اللوكيشن المرتبط مع الاسم
 to get the name that the user typing and take the Location of this
  final ref = FirebaseDatabase.instance.ref();
  final SSnapshot = ref.child("Products/./Location").get();
   */

  @override
  Widget buildSuggestions(BuildContext context) {
/*
  final Suggestions = names.where((name){ // list what is in Suggestions list but here with condition
  return name.toLowerCase().contains((query.toLowerCase()));
  });
*/
    /* if the Location and Name stored in same list and each with its own
  final Suggestions = query.isEmpty
  ? names
  : names.where((p)=> p.Location.startwith(query)).toList();
 */
    final Suggestions = query.isEmpty
        ? names
        : names.where((p)=> p.startsWith(query)).toList();// هنا لو نبي يكون دايم يعرض شيء قبل يبحث المتسوق

    // final Suggestions = names;
    return Suggestions.isEmpty
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

        //  final  String names = Suggestions[index];

        onTap: () {
          showResults(context);
        },

// هنا المفروض قبل كل لوكيشن يطلع له ايكون ويكون يمين مع العربي :)
        trailing:
        Icon(Icons.location_on_outlined,
          color: appColor,
        ),

        // نحتاج column لو بنعرض اللوكيشن وتحته الاسم لو ضبطت :)
        title:
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[

            //if the Location and Name stored in same list and each with its own
            //Text(Suggestions.Name,
            //
            // to incress UX I added highlite(bold them) letter by letter if they search but i can't see if its works in Arabic or not
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
                )),



            /*if the Location and Name stored in same list and each with its own
                    Text(Suggestions.Location,
                  Text(
                    Suggestions.elementAt(index),
                    style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'CartToGo',
                   ),
                   textAlign: TextAlign.right,
                   ),*/


            // ],
            //  ),
            Divider() // to arrange them and make it comfortable to eye
          ],
        ),
      ),
    );
  }
}
