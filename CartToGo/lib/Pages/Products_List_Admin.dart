import 'package:carttogo/Data/Mock_data.dart';
import 'package:carttogo/widgets/Admin_Products_Widgets.dart';
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
  @override
  Widget build(BuildContext context) {
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
                          fontSize: 17,
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


        //جاري التعديل
        body: SingleChildScrollView(
    // child: Padding(
    // padding: const EdgeInsets.all(30.0),
    child:
    Column(
    mainAxisAlignment: MainAxisAlignment.center,
      children:
      products.map((e) {
        return Admin_Products_Widgets(e);
      }).toList(),
    )
    //)
    ,)
      //------------------------------------------------------------

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
}



