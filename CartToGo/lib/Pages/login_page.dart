import 'package:carttogo/Pages/Navigation.dart';
import 'package:carttogo/Pages/register_page.dart';
import 'package:carttogo/Pages/welcome_page.dart';
import 'package:carttogo/Pages/forgetPassword_page.dart';
import 'package:carttogo/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'LoyaltyCard.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  labelText: "البريد الالكتروني",
                                  labelStyle: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  hintText: "أدخل بريدك الالكتروني",
                                  hintStyle: TextStyle(fontSize: 18),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide:
                                        BorderSide(width: 2, color: appColor),
                                  ),
                                  suffixIcon: Icon(Icons.email_outlined,
                                      color: appColor)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
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
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  labelText: "كلمة المرور",
                                  labelStyle: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  hintText: "أدخل كلمة المرور",
                                  hintStyle: TextStyle(fontSize: 18),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide:
                                        BorderSide(width: 2, color: appColor),
                                  ),
                                  suffixIcon: Icon(Icons.lock_outline_rounded,
                                      color: appColor)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء ادخال كلمة المرور';
                                }
                                if (value.length < 8) {
                                  return ("كلمة المرور يجب أن تتكون من 8 خانات فأعلى");
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {})),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ForgetPassword();
                            }));
                          },
                          child: const Text(
                            'نسيت كلمة المرور؟',
                            style: TextStyle(
                                color: appColor, fontWeight: FontWeight.bold),
                          )),

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
                          onPressed: () {
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text)
                                .then((value) {
                              print("Created New Account");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoyaltyCard()));
                            }).onError((error, stackTrace) {
                              print("Error ${error.toString()}");
                            });
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return const Navi();
                            // }));
                          },
                          child: const Text('تسجيل الدخول')),
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
                    ]))));
  }
}
