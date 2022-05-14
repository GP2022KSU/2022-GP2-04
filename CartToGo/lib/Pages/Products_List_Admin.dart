import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:carttogo/main.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_button/animated_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carttogo/Pages/welcome_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carttogo/Pages//AdminAddProduct.dart';


class Products_List_Admin extends StatefulWidget {
  @override
  State<Products_List_Admin> createState() => _Products_List_Admin();
}

class _Products_List_Admin extends State<Products_List_Admin> {
  final fb = FirebaseDatabase.instance;
  TextEditingController second = TextEditingController();
  TextEditingController third = TextEditingController();
  var l;
  var g;
  var k;
  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child('Products');

    return Scaffold(

      //بتن يوديه لصفحة الاد
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RealtimeDatabaseInsert();
          }));
        },
        icon: Icon(Icons.add),
        label: Text(
          "إضافة منتج جديد",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'CartToGo',
            fontSize: 17,
          ),
        ),
        backgroundColor: appColor,
      ),
      //------------------------------------------------------------

      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white24,
        title: Text(
          "المنتجات",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'CartToGo',
          ),
        ),

        //بتن الخروج
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
        //------------------------------------------------------------

        centerTitle: true,
        elevation: 0,
      ),

     // body: SingleChildScrollView(
     //child: Padding(
     //padding: const EdgeInsets.all(8.0),
     // child: Column(
      //    children: <Widget>[



      body:FirebaseAnimatedList(
        padding: const EdgeInsets.all(8.0),
        query: ref,
        shrinkWrap: true,
        itemBuilder: (context, snapshot, animation, index) {

          var v =
          snapshot.value.toString();
          g = v.replaceAll(
              RegExp("{|}|Name: |Price: |Size: |Quantity: |Category: |Brand: |Barcode: "), "");
          g.trim();
          l = g.split(',');

          return GestureDetector(
              onTap: () {
                setState(() {
                  k = snapshot.key;
                });


                //  جاري التضبيط >>>> مربع الابديت حقهم الميثود حقتها تحت
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(

                    title: Container(
                      decoration: BoxDecoration(border: Border.all()),
                      child: TextField(
                        controller: second,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Name',
                        ),
                      ),
                    ),

                    content: Container(
                      decoration: BoxDecoration(border: Border.all()),
                      child: TextField(
                        controller: third,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Brand',
                        ),
                      ),
                    ),

                    actions: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        color: Color.fromARGB(255, 0, 22, 145),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () async {
                          await upd();
                          Navigator.of(ctx).pop();
                        },
                        color: Color.fromARGB(255, 0, 22, 145),
                        child: Text(
                          "Update",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              //------------------------------------------------------------

              // ترتيب الليست واظهار المنتجات
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),

                    child: ListTile(

                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.white,),
                        borderRadius: BorderRadius.circular(10),),

                      tileColor: Color.fromARGB(229, 229, 227, 227),

                      trailing: IconButton(
                        tooltip: "حذف المنتج",
                        icon: Icon(
                          Icons.delete,
                          color: Color.fromARGB(255, 255, 0, 0),
                        ),

                        onPressed: () {
                          var EE = ref.child(snapshot.key!);
                          _DeleteOrNot(EE);
                        },
                      ),

                      leading: IconButton(
                        tooltip: "تعديل المنتج",
                        icon: Icon(
                          Icons.edit,
                          color: Color.fromARGB(255, 94, 90, 90),
                        ),
                        onPressed: ()async {
                          // await upd();
                          // Navigator.of(ctx).pop();

                        },
                      ),

                      title: Text(
                        l[5],
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CartToGo',
                          fontSize: 17,
                        ),
                      ),

                      subtitle: Text(
                        "\t" +  "الحجم: "+  l[3]+ "\n"
                            "\t" +  "العلامة التجارية: "+  l[0]+ "\n"
                            + "\t" +
                            "السعر:" +l[2] + " ريال" + "\n"
                            + "\t" +
                            "الكمية:" +l[4] ,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CartToGo',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            //------------------------------------------------------------

          );
        },
      ),
     // ]),
   //  ),
     // )
    );
  }

  //ميثود للخروج
  void _showMyDialog() async {
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
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      "هل تريد تسجيل الخروج؟",
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
                          await FirebaseAuth.instance.signOut();
                          print(
                              "UID: ${FirebaseAuth.instance.currentUser?.uid}");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WelcomePage()));
                        },
                        child: Center(
                          child: Text(
                            "خروج",
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

  // ميثود للتأكد من الحذف
  void _DeleteOrNot(var EE) async {
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
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                          await EE.remove();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Products_List_Admin()));
                        },

                        child: Center(
                          child: Text(
                            "نعم",
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
                          child: Text(
                            "لا",
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


//ميثود الابديت حقتهم
  upd() async {
    DatabaseReference ref1 = FirebaseDatabase.instance.ref("Products/$k");
// Only update the name, leave the age and address!
    await ref1.update({
      "Name": second.text,
      "Brand": third.text,
    });
    second.clear();
    third.clear();
  }
}

