import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:carttogo/main.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carttogo/Pages/welcomePage.dart';
import 'package:carttogo/Pages/addNewProduct.dart';
import 'package:flutter/rendering.dart';

class ProductsListAdmin extends StatefulWidget {
  @override
  State<ProductsListAdmin> createState() => _ProductsListAdmin();
}

class _ProductsListAdmin extends State<ProductsListAdmin> {
  bool isScrolled = false;
  final fb = FirebaseDatabase.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController second = TextEditingController();
  TextEditingController third = TextEditingController();
  TextEditingController zero = TextEditingController();
  var l;
  var g;
  var k;

  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child('Products');

    return Scaffold(
      // add new prduct button to navigate the admin to add new product form
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddNewProduct(" ");
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
// end of add new prodcut button

      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white24,
        title: Text("المنتجات",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),

        // logout button
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
            // end of logout button
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            setState(() {
              isScrolled = true;
            });
          } else if (notification.direction == ScrollDirection.reverse) {
            setState(() {
              isScrolled = false;
            });
          }
          return true;
        },
        child: FirebaseAnimatedList(
          padding: const EdgeInsets.all(8.0),
          query: ref,
          shrinkWrap: true,
          itemBuilder: (context, snapshot, animation, index) {
            var v = snapshot.value.toString();
            g = v.replaceAll(
                RegExp(
                    "{|}|Name: |Price: |Size: |Quantity: |Category: |Brand: |Barcode: |Location: "),
                "");
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
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                      onPressed: () async {
                        setState(() {
                          k = snapshot.key;
                        });
                        _UpdateOrNot();
                      },
                    ),
                    title: Text(
                      l[3],
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'CartToGo',
                        fontSize: 17,
                      ),
                    ),
                    subtitle: Text(
                      "\t" +
                          "الحجم: " +
                          l[0] +
                          "\n"
                              "\t" +
                          "العلامة التجارية: " +
                          l[6] +
                          "\n" +
                          "\t" +
                          "السعر:" +
                          l[5] +
                          " ريال" +
                          "\n" +
                          "\t" +
                          "الكمية:" +
                          l[4] +
                          "\n" +
                          "\t" +
                          "الموقع:" +
                          l[2],
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
            ));
          },
        ),
      ),
    );
  }

  //logout dialog, to ensure that the admin want to log out or not
  void _showMyDialog() async {
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
                    Text("هل تريد تسجيل الخروج؟",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        )),
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
                                child: Text("خروج",
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
                                child: Text("إلغاء",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                    )))))
                  ])));
        });
  }

  // dialog to ensure the admin wants to delete a product or not
  void _DeleteOrNot(var delete) async {
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
                              await delete.remove();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductsListAdmin()));
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
                                      fontWeight: FontWeight.w400,
                                    )))))
                  ])));
        });
  }

// dialog to enter the new product info
  void _UpdateOrNot() async {
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
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                          key: _formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text(" أدخل بيانات المنتج",
                                        style: TextStyle(
                                          fontSize: 19,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ))),
                                SizedBox(height: 15),
                                Divider(
                                  height: 1.5,
                                ),
                                const SizedBox(height: 15),

                                // new product's price
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'(^\d*\.?\d*)'))
                                      ], // Only numbers can be entered

                                      controller: third,
                                      decoration: const InputDecoration(
                                        labelText: "السعر",
                                        labelStyle: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                        hintText: "أدخل سعر المنتج ",
                                        hintStyle: TextStyle(fontSize: 14),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                          borderSide: BorderSide(
                                              width: 1.5,
                                              color: Color(0xFFAFAEAE)),
                                        ),
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
                                const SizedBox(height: 15),

                                // new product's quantity
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ], // Only numbers can be entered
                                      controller: second,
                                      decoration: const InputDecoration(
                                        labelText: "الكمية",
                                        labelStyle: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                        hintText: "أدخل كمية المنتج ",
                                        hintStyle: TextStyle(fontSize: 14),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                          borderSide: BorderSide(
                                              width: 1.5,
                                              color: Color(0xFFAFAEAE)),
                                        ),
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
                                SizedBox(height: 15),

                                // new product's location
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: zero,
                                      decoration: const InputDecoration(
                                        labelText: "الموقع",
                                        labelStyle: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                        hintText: "أدخل موقع المنتج ",
                                        hintStyle: TextStyle(fontSize: 14),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                          borderSide: BorderSide(
                                              width: 1.5,
                                              color: Color(0xFFAFAEAE)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'الرجاء كتابة موقع المنتج';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {}),
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
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (second.text.isNotEmpty &&
                                                third.text.isNotEmpty) {
                                              updateProductInfo();
                                            }
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ProductsListAdmin();
                                            }));
                                          }
                                        },
                                        child: Center(
                                            child: Text("تحديث",
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: appColor,
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
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return ProductsListAdmin();
                                          }));
                                        },
                                        child: Center(
                                            child: Text("إلغاء",
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400,
                                                )))))
                              ])))));
        });
  }

// add the new product's info to the database
  updateProductInfo() async {
    DatabaseReference ref1 = FirebaseDatabase.instance.ref("Products/$k");
    await ref1.update({
      "Quantity": int.tryParse(second.text),
      "Price": double.tryParse(third.text),
      "Location": zero.text, // بعدل الدايلوق
    });
    second.clear();
    third.clear();
    zero.clear();
  }

  void _showDialog(String pass) async {
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
                    Text(pass,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        )),
                    SizedBox(height: 20),
                    Divider(
                      height: 2,
                      color: Colors.black,
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
                                child: Text("موافق",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: appColor)))))
                  ])));
        });
  }
}
