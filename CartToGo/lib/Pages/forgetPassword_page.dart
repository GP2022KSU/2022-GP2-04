import 'package:carttogo/Pages/welcome_page.dart';

import 'package:carttogo/main.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Image(
                          image: AssetImage('assets/images/blueCart.png')),
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide:
                                        BorderSide(width: 2, color: appColor)),
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
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {}),
                      ),
                      const SizedBox(height: 40.0),
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
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const WelcomePage();
                            }));
                          },
                          child: const Text('إعادة تعيين كلمة المرور')),
                      const SizedBox(height: 15.0),
                    ]),
              )),
        ));
  }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       backgroundColor: Colors.white,
  //       body: SingleChildScrollView(
  //         child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: <Widget>[
  //                   const Image(
  //                       image: AssetImage('assets/images/blueCart.png')),
  //                   Directionality(
  //                     textDirection: TextDirection.rtl,
  //                     child: TextFormField(
  //                         keyboardType: TextInputType.visiblePassword,
  //                         obscureText: true,
  //                         decoration: const InputDecoration(
  //                             labelText: "كلمة المرور الجديدة",
  //                             labelStyle:
  //                                 TextStyle(fontSize: 20, color: Colors.black),
  //                             hintText: "أدخل كلمة المرور الجديدة",
  //                             hintStyle: TextStyle(fontSize: 18),
  //                             enabledBorder: OutlineInputBorder(
  //                               borderRadius:
  //                                   BorderRadius.all(Radius.circular(20.0)),
  //                               borderSide:
  //                                   BorderSide(width: 2, color: appColor),
  //                             ),
  //                             suffixIcon: Icon(Icons.lock_outline_rounded,
  //                                 color: appColor)),
  //                         onChanged: (value) {
  //                           setState(() => password = value);
  //                         }),
  //                   ),
  //                   const SizedBox(height: 10.0),
  //                   Directionality(
  //                     textDirection: TextDirection.rtl,
  //                     child: TextFormField(
  //                         keyboardType: TextInputType.visiblePassword,
  //                         decoration: const InputDecoration(
  //                             labelText: "أعد ادخال كلمة المرور",
  //                             labelStyle:
  //                                 TextStyle(fontSize: 20, color: Colors.black),
  //                             enabledBorder: OutlineInputBorder(
  //                               borderRadius:
  //                                   BorderRadius.all(Radius.circular(20.0)),
  //                               borderSide:
  //                                   BorderSide(width: 2, color: appColor),
  //                             ),
  //                             suffixIcon: Icon(Icons.lock_outline_rounded,
  //                                 color: appColor)),
  //                         onChanged: (value) {
  //                           setState(() => reEnterPassword = value);
  //                         }),
  //                   ),
  //                   const SizedBox(height: 40.0),
  //                   ElevatedButton(
  //                       style: ButtonStyle(
  //                           elevation: MaterialStateProperty.all(8.0),
  //                           textStyle: MaterialStateProperty.all(
  //                               const TextStyle(
  //                                   fontSize: 20, fontFamily: 'CartToGo')),
  //                           fixedSize:
  //                               MaterialStateProperty.all(const Size(270, 50)),
  //                           shape: MaterialStateProperty.all<
  //                                   RoundedRectangleBorder>(
  //                               RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(30.0))),
  //                           backgroundColor:
  //                               MaterialStateProperty.all(appColor),
  //                           foregroundColor:
  //                               MaterialStateProperty.all(Colors.white)),
  //                       onPressed: () {
  //                         Navigator.push(context,
  //                             MaterialPageRoute(builder: (context) {
  //                           return const WelcomePage();
  //                         }));
  //                       },
  //                       child: const Text('إعادة تعيين كلمة المرور')),
  //                   const SizedBox(height: 15.0),
  //                 ])),
  //       ));
  // }
}
