import 'package:flutter/material.dart';
import 'package:carttogo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carttogo/Pages/login_page.dart';
import 'package:carttogo/Pages/Navigation.dart';


class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Image(
                        image: AssetImage('assets/images/blueCart.png')),
                    Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                            controller: _userNameController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: "اسم المستخدم",
                                labelStyle: TextStyle(
                                    fontSize: 20, color: Colors.black),
                                hintText: "أدخل اسم المستخدم",
                                hintStyle: TextStyle(fontSize: 18),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide:
                                        BorderSide(width: 2, color: appColor)),
                                suffixIcon: Icon(Icons.account_box_outlined,
                                    color: appColor)),
                            validator: (value) {
                              if (value!.length == 0) {
                                return 'الرجاء كتاتبة اسم المستخدم';
                              }
                            },
                            onChanged: (value) {})),
                    const SizedBox(height: 10.0),
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide:
                                        BorderSide(width: 2, color: appColor)),
                                suffixIcon: Icon(Icons.lock_outline_rounded,
                                    color: appColor)),
                            validator: (value) {
                              if (value!.length == 0) {
                                return 'الرجاء ادخال كلمة المرور';
                              }
                              if (value.length < 8) {
                                return ("كلمة المرور يجب أن تتكون من 8 خانات فأعلى");
                              }
                              if (!(value.contains(RegExp(r'[A-Z]'), 0) ||
                                  value.contains(RegExp(r'[a-z]'), 0) ||
                                  value.contains(RegExp(r'[0-9]'), 0))) {
                                return "كلمة المرور يجب ان تحتوي على حرف كبير وحرف صغير ورقم";
                              }
                            },
                            onChanged: (value) {})),
                    const SizedBox(height: 10.0),
                    Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                            controller: _confirmPasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            decoration: const InputDecoration(
                                labelText: "أعد ادخال كلمة المرور",
                                labelStyle: TextStyle(
                                    fontSize: 20, color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide:
                                        BorderSide(width: 2, color: appColor)),
                                suffixIcon: Icon(Icons.lock_outline_rounded,
                                    color: appColor)),
                            validator: (value) {
                              if (value!.length == 0) {
                                return 'الرجاء اعادة ادخال كلمة المرور';
                              }
                              if (_confirmPasswordController.text !=
                                  _passwordController.text) {
                                return "يجب أن تتطابق كلمتا المرور";
                              }
                            },
                            onChanged: (value) {})),

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
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text)
                              .then((value) {
                            print("Created New Account");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Navi()));
                          }).onError((error, stackTrace) {
                            print("Error ${error.toString()}");
                          });
                          // الي تحت يمكن احذفه
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                          }
                        },
                        child: const Text('تسجيل ')),
                    const SizedBox(height: 15.0),

                    const Text('لديك حساب بالفعل؟'),
                    TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return LoginPage();
                          }));
                        },
                        child: const Text(
                          'قم بتسجيل الدخول',
                          style: TextStyle(
                              color: appColor, fontWeight: FontWeight.bold),
                        ))
                  ]),
            ),
          ),
        ));
  }
}
