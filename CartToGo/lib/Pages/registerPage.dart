import 'package:flutter/material.dart';
import 'package:carttogo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carttogo/Pages/loginPage.dart';
import 'package:carttogo/Pages/Navigation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math' as math;

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //create register form
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
                        width: 200,
                        height: 200,
                        image: AssetImage('assets/images/blueCart.png')),
                    Center(
                      //username text feild
                      child: Directionality(
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      borderSide: BorderSide(
                                          width: 2, color: appColor)),
                                  suffixIcon: Icon(Icons.account_box_outlined,
                                      color: appColor)),
                              //validation to check if the shopper doesn't write any name
                              validator: (value) {
                                if (value!.length == 0) {
                                  return 'الرجاء كتابة اسم المستخدم';
                                }
                              },
                              onChanged: (value) {})),
                      //end of username text feild
                    ),
                    const SizedBox(height: 10.0),

                    //email text felid
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
                            //email validation, the shopper should enter email as xxxx@xxxxx.xxx
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

                    //password textfelid
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

                            //validation to check if the shopper
                            //enters a password containing 8 characters with 1 capital letter, 1 small letter, and 1 number, or nothing
                            validator: (value) {
                              if (value!.length == 0) {
                                return 'الرجاء ادخال كلمة المرور';
                              }
                              if (value.length < 8) {
                                return ("كلمة المرور يجب أن تتكون من 8 خانات فأعلى");
                              }
                              if (!(value.contains(RegExp(r'[A-Z]')) &&
                                  value.contains(RegExp(r'[a-z]')) &&
                                  value.contains(RegExp(r'[0-9]')))) {
                                return "كلمة المرور يجب ان تحتوي على حرف كبير وحرف صغير ورقم";
                              }
                              return null;
                            },
                            onChanged: (value) {})),
                    //end of password text felid

                    const SizedBox(height: 10.0),
                    //re enter password text field
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

                            //validation to check if the shopper enter the password and the two password are match
                            validator: (value) {
                              if (value!.length == 0) {
                                return 'الرجاء اعادة ادخال كلمة المرور';
                              }
                              if (_confirmPasswordController.text !=
                                  _passwordController.text) {
                                return "يجب أن تتطابق كلمتا المرور";
                              }
                              return null;
                            },
                            onChanged: (value) {})),
                    //end of re enter password text field

                    const SizedBox(height: 40.0),

                    //register button
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
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              )
                                  .then((value) {
                                print("Created New Account");
                                String? UID =
                                    FirebaseAuth.instance.currentUser?.uid;
                                AddShopper(UID.toString());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Navi()));
                              });

                              //show register error messages to the user,
                              //whether the password doesn't match the requirements or the email is used by another user
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                _showMyDialog("كلمة المرور ضعيفة");
                              } else if (e.code == 'email-already-in-use') {
                                _showMyDialog(
                                    "البريد الالكتروني مستخدم من قبل متسوق اخر");
                              }
                              print(e);
                            }
                            CircularProgressIndicator();
                          }
                        },
                        child: const Text('تسجيل ')),
                    //end of register button

                    const SizedBox(height: 15.0),

                    //if it's a already a user with account, move to login page
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
            ), //end of register form
          ),
        ));
  }

//add new shopper to the database
  void AddShopper(String uid) async {
    String LoyaltyCardID = await generateLoyaltyCardID(uid);
    DatabaseReference ref = FirebaseDatabase.instance.ref("Shopper/$uid");
    //Generate loyaltycard id 10 QRUidFinder unique id
    await ref.set({
      "LoyaltyCardID": LoyaltyCardID.toString(), //need loyaltycard id
      "Points": 0,
      "Username": _userNameController.text,
      "Email": _emailController.text,
      "Carts": {
        "ConnectedToCart": false, //always false
        "DeletingProduct": false, //always false
        "FutureCartNumber": 1, //always 1
        "Total": 0, //always 0
        "TotalAfterPoints": 0,
        "NumOfProducts": 0, //always 0
      },
      "PurchaseHistory": {
        "New": {"NoPurchase": true, "Price": 1, "SubCategory": "Test"}
      },
    });
    final databaseRef = FirebaseDatabase.instance.ref();
    databaseRef.child("QRUidFinder").child("$LoyaltyCardID").set({
      "shopperID": uid,
    });
  }

// dialog to show an error message when the shopper enter a weak password
// or when the shopper use email used already by other shopper
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
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    SizedBox(height: 15),
                    Text(
                      "حدث خطأ",
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    SizedBox(height: 15),
                    Center(
                        child: Text(error,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ))),
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
                            ))))
                  ])));
        });
  }
}

Future<String> generateLoyaltyCardID(String id) async {
  //dart unique string generatofinal ref = FirebaseDatabase.instance.ref();
  bool check = true;
  String string1 = "";
  late String _LoyaltyCardID;
  while (check) {
    _LoyaltyCardID = string1.toString() +
        math.Random().nextInt(9).toString() +
        math.Random().nextInt(9999).toString() +
        math.Random().nextInt(9999).toString() +
        "S";
    check = await bringLoyaltyCard(_LoyaltyCardID);
  }
  return _LoyaltyCardID;
}

Future<bool> bringLoyaltyCard(String random) async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child("QRUidFinder/$random").get();
  print("Check: " + snapshot.value.toString());

  if (snapshot.value == null) {
    return false;
  }
  return true;
}
