import 'package:flutter/material.dart';
import 'package:carttogo/main.dart';
import 'package:carttogo/Pages/Navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //final AuthService auth = AuthService();

  String userName = '';
  String email = '';
  String password = '';
  String reEnterPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //background lines
                    const Image(
                        image: AssetImage('assets/images/blueCart.png')),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: "اسم المستخدم",
                              labelStyle:
                                  TextStyle(fontSize: 20, color: Colors.black),
                              hintText: "أدخل اسم المستخدم",
                              hintStyle: TextStyle(fontSize: 18),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(width: 2, color: appColor),
                              ),
                              suffixIcon: Icon(Icons.account_box_outlined,
                                  color: appColor)),
                          onChanged: (value) {
                            setState(() => userName = value);
                          }),
                    ),
                    const SizedBox(height: 10.0),
                    //email felid
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              labelText: "البريد الالكتروني",
                              labelStyle:
                                  TextStyle(fontSize: 20, color: Colors.black),
                              hintText: "أدخل بريدك الالكتروني",
                              hintStyle: TextStyle(fontSize: 18),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(width: 2, color: appColor),
                              ),
                              suffixIcon:
                                  Icon(Icons.email_outlined, color: appColor)),
                          onChanged: (value) {
                            setState(() => email = value);
                          }),
                    ),
                    const SizedBox(height: 10.0),
                    //password felid
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: "كلمة المرور",
                              labelStyle:
                                  TextStyle(fontSize: 20, color: Colors.black),
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
                          onChanged: (value) {
                            setState(() => password = value);
                          }),
                    ),
                    const SizedBox(height: 10.0),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                              labelText: "أعد ادخال كلمة المرور",
                              labelStyle:
                                  TextStyle(fontSize: 20, color: Colors.black),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(width: 2, color: appColor),
                              ),
                              suffixIcon: Icon(Icons.lock_outline_rounded,
                                  color: appColor)),
                          onChanged: (value) {
                            setState(() => reEnterPassword = value);
                          }),
                    ),

                    const SizedBox(height: 40.0),
                    //login button
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
                                    borderRadius: BorderRadius.circular(30.0))),
                            backgroundColor:
                                MaterialStateProperty.all(appColor),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Navi();
                          }));
                        },
                        child: const Text('تسجيل ')),
                  ]),
            ),
          ),
        ));
  }
}
