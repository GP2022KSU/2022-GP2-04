// ignore_for_file: prefer_const_constructors
import 'package:carttogo/Pages/Navigation.dart';
import 'package:carttogo/Pages/Products_List_Admin.dart';
import 'package:carttogo/Pages/registerPage.dart';
import 'package:carttogo/Pages/forgetPassword_page.dart';
import 'package:carttogo/Pages/Cashier.dart';
import 'package:carttogo/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

//Create a login form include the email & password
class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool checkLoading = true;
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //background image
                        const Image(
                            width: 300,
                            height: 300,
                            image: AssetImage('assets/images/blueCart.png')),

                        Center(
                          heightFactor: 1.2,
                          //email text field
                          child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                      labelText: "البريد الالكتروني",
                                      labelStyle: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                      hintText: "أدخل بريدك الالكتروني",
                                      hintStyle: TextStyle(fontSize: 18),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                        borderSide: BorderSide(
                                            width: 2, color: appColor),
                                      ),
                                      suffixIcon: Icon(Icons.email_outlined,
                                          color: appColor)),
                                  //email validation, the shopper should enter email as xxxx@xxxxx.xxx
                                  validator: (value) {
                                    if (value!.length == 0) {
                                      return 'الرجاء ادخال البريد الالكتروني';
                                    }
                                    if (!RegExp(
                                            "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                        .hasMatch(value)) {
                                      return ("أدخل بريد الكتروني صحيح");
                                    }
                                  },
                                  onChanged: (value) {})),
                        ), //end of email text felid

                        const SizedBox(height: 10.0),
                        //password text felid
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                                controller: _passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                decoration: const InputDecoration(
                                    labelText: "كلمة المرور",
                                    labelStyle: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                    hintText: "أدخل كلمة المرور",
                                    hintStyle: TextStyle(fontSize: 18),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      borderSide:
                                          BorderSide(width: 2, color: appColor),
                                    ),
                                    suffixIcon: Icon(Icons.lock_outline_rounded,
                                        color: appColor)),
                                validator: (value) {
                                  if (value!.length == 0) {
                                    return 'الرجاء ادخال كلمة المرور';
                                  }
                                  if (value.length < 8) {
                                    return ("كلمة المرور يجب أن تتكون من 8 خانات فأعلى");
                                  }
                                },
                                onChanged: (value) {})),
                        //end of password text felid

                        //if the shopper forgets its password, move to forget password page
                        GestureDetector(
                          child: Text(
                            ' نسيت كلمة المرور؟ اضغط هنا',
                            style: TextStyle(
                              color: appColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ForgetPassword(),
                          )),
                        ),

                        const SizedBox(height: 80.0),
                        //login button
                        ElevatedButton(
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(8.0),
                                textStyle: MaterialStateProperty.all(
                                    const TextStyle(
                                        fontSize: 20, fontFamily: 'CartToGo')),
                                fixedSize: MaterialStateProperty.all(
                                    const Size(270, 50)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0))),
                                backgroundColor:
                                    MaterialStateProperty.all(appColor),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: _emailController.text,
                                          password: _passwordController.text)
                                      .then((value) {
                                    String? UID =
                                        FirebaseAuth.instance.currentUser?.uid;

                                    //check if the logged-in user is an admin or cashier or shopper to give the privilege
                                    if (UID.toString() == //admins IDs
                                            "1NH5Wj2RzTXWZxLcTcnDDdKru7I3" ||
                                        UID.toString() ==
                                            "jCG3miIP7AdaVVfY20lCn1MVWqR2") {
                                      print("Admin Logged in");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Products_List_Admin()));
                                    } else if ((UID.toString() == //cashier IDs
                                        "OMCkaR8mdxNDmDE1O7gkFFd9HyX2")) {
                                      print("Cashier Logged in");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  scanInovice()));
                                    } else {
                                      //any other ID represents the shopper ID
                                      print("Shopper Logged in");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Navi()));
                                    }
                                  });
                                  //show login error messages to the user,
                                  //whether it does not have an account or its wrong password
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    _showMyDialog(
                                        "البريد الالكتروني غير مسجل مسبقا");
                                  } else if (e.code == "ERROR_WRONG_PASSWORD" ||
                                      e.code == "wrong-password") {
                                    _showMyDialog("كلمة مرور خاطئة");
                                  }
                                  print(e);
                                }
                                CircularProgressIndicator();
                              }
                            },
                            child: const Text('تسجيل الدخول')),
                        //end of login button

                        //if it's a new shopper, move to register page
                        const SizedBox(height: 15.0),
                        const Text('متسوق جديد؟'),
                        TextButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return RegisterPage();
                              }));
                            },
                            child: const Text(
                              'قم بإنشاء حساب',
                              style: TextStyle(
                                  color: appColor, fontWeight: FontWeight.bold),
                            ))
                      ]),
                )))); //end of login form
  }

  void _showMyDialog(String error) async {
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      "حدث خطأ",
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    SizedBox(height: 15),
                    Text(
                      error,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
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
                          child: Text(
                            "موافق",
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: appColor),
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
