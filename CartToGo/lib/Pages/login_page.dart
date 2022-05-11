// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:carttogo/Pages/AdminAddProduct.dart';
import 'package:carttogo/Pages/Navigation.dart';
import 'package:carttogo/Pages/register_page.dart';
import 'package:carttogo/Pages/forgetPassword_page.dart';
import 'package:carttogo/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils.dart';

class LoginPage extends StatefulWidget {
  // final VoidCallback onClickedSignUp;

  // const LoginPage({
  //   Key? key,
  //   required this.onClickedSignUp,
  // }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

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
                        //background lines
                        const Image(
                            image: AssetImage('assets/images/blueCart.png')),
                        //email felid
                        Directionality(
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
                                      borderSide:
                                          BorderSide(width: 2, color: appColor),
                                    ),
                                    suffixIcon: Icon(Icons.email_outlined,
                                        color: appColor)),
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
                        const SizedBox(height: 10.0),
                        //password felid
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

                        GestureDetector(
                          child: Text(
                            'نسيت كلمة المرور؟?',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: appColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ForgetPassword(),
                          )),
                        ),
                        // TextButton(
                        //     onPressed: () {
                        //       Navigator.push(context,
                        //           MaterialPageRoute(builder: (context) {
                        //         return ForgetPassword();
                        //       }));
                        //     },
                        //     child: const Text(
                        //       'نسيت كلمة المرور؟',
                        //       style: TextStyle(
                        //           color: appColor, fontWeight: FontWeight.bold),
                        //     )),

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
                                    if (UID.toString() ==
                                        "ieCOHKL0cPhTUa58IcUaEapvhjD3") {
                                      print("Admin Logged in");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AdminAddProduct()));
                                    } else {
                                      print("Shopper Logged in");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Navi()));
                                    }
                                  });
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
                        const SizedBox(height: 15.0),
                        // RichText(
                        //   text: TextSpan(
                        //     style: TextStyle(color: Colors.white, fontSize: 20),
                        //     text: 'متسوق جديد؟',
                        //     children: [
                        //       TextSpan(
                        //         recognizer: TapGestureRecognizer()
                        //           ..onTap = widget.onClickedSignUp,
                        //         text: 'قم بإنشاء حساب',
                        //         style: TextStyle(
                        //           decoration: TextDecoration.underline,
                        //           color: Theme.of(context).colorScheme.secondary,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // )
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
                ))));
  }

  void _showMyDialog(String error) async {
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
                      "حدث خطأ",
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    SizedBox(height: 15),
                    Text(
                      error, //Product name for IOS 1 android 4
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(
                      height: 1,
                    ),
                  ],
                ),
              ));
        });
  }
}
