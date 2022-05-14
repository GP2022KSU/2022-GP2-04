import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:carttogo/main.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carttogo/Pages/welcome_page.dart';
import 'package:carttogo/Pages//AdminAddProduct.dart';
//import ' AdminUpdateProduct.dart';
import 'package:flutter/rendering.dart';

class Products_List_Admin extends StatefulWidget {
  @override
  State<Products_List_Admin> createState() => _Products_List_Admin();
}

class _Products_List_Admin extends State<Products_List_Admin> {
  bool isScrolled = false;
  final fb = FirebaseDatabase.instance;
  final _formKey = GlobalKey<FormState>();
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
        isExtended: isScrolled,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
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
        //------------------------------------------------------------
        centerTitle: true,
        elevation: 0,
      ),

      body:NotificationListener<UserScrollNotification>(
        onNotification: (notification){
          if(notification.direction==ScrollDirection.forward){
            setState(() {
              isScrolled= true;
            });
          }else if(notification.direction==ScrollDirection.reverse){
            setState(() {
              isScrolled= false;
            });
          }
          return true;
        },

        child: FirebaseAnimatedList(
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
                            setState(() {
                              k = snapshot.key;
                            });
                            _UpdateOrNot();
                            /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RealtimeDatabaseUpdate() ));*/
                          },
                        ),

                        title: Text(
                          l[2],
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CartToGo',
                            fontSize: 17,
                          ),
                        ),

                        subtitle: Text(
                          "\t" +  "الحجم: "+  l[0]+ "\n"
                              "\t" +  "العلامة التجارية: "+  l[3]+ "\n"
                              + "\t" +
                              "السعر:" +l[5] + " ريال" + "\n"
                              + "\t" +
                              "الكمية:" +l[] ,
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

  void _UpdateOrNot() async {
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

                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(" أدخل بيانات المنتج",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Divider(
                            height: 1,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 10),
                          //السعر
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ], // Only numbers can be entered
                                //  obscureText: true,
                                controller: third,
                                decoration: const InputDecoration(
                                  labelText: "السعر",
                                  labelStyle:
                                  TextStyle(fontSize: 20, color: Colors.black),
                                  hintText: "أدخل سعر المنتج ",
                                  hintStyle: TextStyle(fontSize: 18),
                                  //  enabledBorder: OutlineInputBorder(
                                  //borderRadius:
                                  //BorderRadius.all(Radius.circular(20.0)),
                                  //   borderSide: BorderSide(width: 2, color: appColor),
                                  // ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء كتابة سعر المنتج';
                                  }
                                  if (value.contains(RegExp(r'[A-Z]')) &&
                                      value.contains(RegExp(r'[a-z]'))) {
                                    return 'سعر المنتج يجب ان لا يحتوي على احرف';
                                  }
                                  return null;
                                },
                                onChanged: (value) {}),
                          ),
                          const SizedBox(height: 10),

                          const SizedBox(height: 10),
                          //الكمية
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ], // Only numbers can be entered
                                //  obscureText: true,
                                controller: second,
                                decoration: const InputDecoration(
                                  labelText: "الكمية",
                                  labelStyle:
                                  TextStyle(fontSize: 20, color: Colors.black),
                                  hintText: "أدخل كمية المنتج ",
                                  hintStyle: TextStyle(fontSize: 18),
                                  /* enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                   BorderRadius.all(Radius.circular(20.0)),
                                    borderSide: BorderSide(width: 2, color: appColor),
                                  ),*/
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء كتابة كمية المنتج';
                                  }
                                  if (value.contains(RegExp(r'[A-Z]')) &&
                                      value.contains(RegExp(r'[a-z]'))) {
                                    return ' كمية المنتج يجب ان لا تحتوي على احرف';
                                  }
                                  return null;
                                },
                                onChanged: (value) {}),
                          ),
                          const SizedBox(height: 10),

                          SizedBox(
                            height: 11,
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(8.0),
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(
                                          fontSize: 20, fontFamily: 'CartToGo')),
                                  fixedSize:
                                  MaterialStateProperty.all(const Size(270, 50)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(90.0))),
                                  backgroundColor:
                                  MaterialStateProperty.all(appColor),
                                  foregroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Processing Data')),
                                  );
                                  if (second.text.isNotEmpty &&
                                      third.text.isNotEmpty ) {
                                    upd();
                                  }
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return Products_List_Admin();
                                      }));
                                }
                              },
                              child: const Text('تحديث')),

                          SizedBox(height: 10,),
                          ElevatedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(8.0),
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(
                                          fontSize: 20, fontFamily: 'CartToGo')),
                                  fixedSize:
                                  MaterialStateProperty.all(const Size(270, 50)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(90.0))),
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                                  foregroundColor:
                                  MaterialStateProperty.all(appColor)),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return Products_List_Admin();
                                    }));
                              },
                              child: const Text('إلغاء')),


                        ]),


                  ),
                ),
              ));
        });}

  upd() async {
    DatabaseReference ref1 = FirebaseDatabase.instance.ref("Products/$k");
    await ref1.update({
      "Quantity": second.text,
      "Price": third.text,
    });
    second.clear();
    third.clear();
  }
}

/*
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    SizedBox(height: 15),
                    Text(
                      "ادخل بيانات المنتج",
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

                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                          keyboardType: TextInputType.text,
                       //   controller: ,
                          decoration: const InputDecoration(
                            labelText: "الحجم",
                            labelStyle:
                            TextStyle(fontSize: 20, color: Colors.black),
                            hintText: "أدخل حجم، وزن المنتج ",
                            hintStyle: TextStyle(fontSize: 18),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(width: 2, color: appColor),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء كتابة حجم المنتج';
                            }
                            return null;
                          },
                          onChanged: (value) {}),
                    ),

                    TextField(
                      controller: first,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'إسم المنتج',
                      ),
                    ),

                    TextField(
                      controller: second,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        labelText: 'الكمية',
                        hintText: 'ادخل كمية المنتج ',
                      ),
                    ),

                    TextField(
                      controller: third,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'السعر',
                      ),
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: InkWell(
                        highlightColor: Colors.grey[200],
                        onTap: () async {
                          await upd();
                          Navigator.of(context).pop();
                         /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Products_List_Admin()));*/
                        },
                        child: Center(
                          child: Text(
                            "تحديث",
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
                            "الغاء",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                  //  ),
                //  ],
               // ),

 */



