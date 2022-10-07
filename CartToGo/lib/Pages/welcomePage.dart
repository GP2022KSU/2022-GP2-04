import 'package:carttogo/Pages/registerPage.dart';
import 'package:carttogo/Pages/loginPage.dart';
import 'package:carttogo/main.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appColor,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          //background image
          const Image(image: AssetImage('assets/images/background.png')),
          const SizedBox(height: 40.0),
          const Text('مرحباً بك',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  shadows: <Shadow>[
                    Shadow(
                        color: Colors.black,
                        offset: Offset(-5.0, 5.0),
                        blurRadius: 15)
                  ])),
          //logo
          const Image(
              image: AssetImage('assets/images/whiteCart.png'), height: 450),
          const SizedBox(height: 40.0),

//two buttons in welcome page, login and register buttons

          //login button, for shoppers, admins, and cashiers
          ElevatedButton(
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(8.0),
                  textStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: 23, fontFamily: 'CartToGo')),
                  fixedSize: MaterialStateProperty.all(const Size(270, 45)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  foregroundColor: MaterialStateProperty.all(Colors.black)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }));
              },
              child: const Text('تسجيل الدخول')),
          //end of login button
          const SizedBox(height: 15.0),

          //register button, only for shoppers
          ElevatedButton(
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(8.0),
                  textStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: 23, fontFamily: 'CartToGo')),
                  fixedSize: MaterialStateProperty.all(const Size(270, 45)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  foregroundColor: MaterialStateProperty.all(Colors.black)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return RegisterPage();
                }));
              },
              child: const Text('تسجيل')),
          //end of register button
        ]));
  }
}
