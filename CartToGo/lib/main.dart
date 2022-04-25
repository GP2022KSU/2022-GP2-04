import 'package:flutter/material.dart';
import 'package:carttogo/Pages/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';

const appColor = Color.fromARGB(255, 20, 77, 220);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cart To Go',
      theme: ThemeData(fontFamily: 'CartToGo', primaryColor: appColor),
      home: const WelcomePage(),
    );
  }
}
