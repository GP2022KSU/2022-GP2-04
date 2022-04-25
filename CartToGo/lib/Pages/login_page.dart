import 'package:carttogo/Pages/Navigation.dart';
import 'package:carttogo/Pages/register_page.dart';
import 'package:carttogo/Pages/welcome_page.dart';
import 'package:carttogo/Pages/forgetPassword_page.dart';
import 'package:carttogo/main.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
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
                    const Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: "البريد الالكتروني",
                            labelStyle:
                                TextStyle(fontSize: 20, color: Colors.black),
                            hintText: "أدخل بريدك الالكتروني",
                            hintStyle: TextStyle(fontSize: 18),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(width: 2, color: appColor),
                            ),
                            suffixIcon:
                                Icon(Icons.email_outlined, color: appColor)),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    //password felid
                    const Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "كلمة المرور",
                          labelStyle:
                              TextStyle(fontSize: 20, color: Colors.black),
                          hintText: "أدخل كلمة المرور",
                          hintStyle: TextStyle(fontSize: 18),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(width: 2, color: appColor),
                          ),
                          suffixIcon:
                              Icon(Icons.lock_outline_rounded, color: appColor),
                        ),
                      ),
                    ),
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
                    TextButton(
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
                                    borderRadius: BorderRadius.circular(30.0))),
                            backgroundColor:
                                MaterialStateProperty.all(appColor),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const Navi();
                          }));
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
                        )),
                  ])),
        ));
  }
}
