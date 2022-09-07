import 'package:carttogo/Pages/Products_List_Admin.dart';
import 'package:carttogo/Pages/scanInovice.dart';
import 'package:carttogo/utils.dart';
import 'package:flutter/material.dart';
import 'package:carttogo/Pages/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carttogo/Pages/Navigation.dart';

const appColor = Color.fromARGB(255, 20, 77, 220);

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Cart To Go',
      theme: ThemeData(fontFamily: 'CartToGo', primaryColor: appColor),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('! مشكلة ما قد حدثت'));
            } else if (snapshot.hasData && (FirebaseAuth.instance.currentUser?.uid).toString() != "jCG3miIP7AdaVVfY20lCn1MVWqR2" 
            && snapshot.hasData &&(FirebaseAuth.instance.currentUser?.uid).toString() != "OMCkaR8mdxNDmDE1O7gkFFd9HyX2") {
              return Navi();
            }
            else if(snapshot.hasData &&(FirebaseAuth.instance.currentUser?.uid).toString() == "jCG3miIP7AdaVVfY20lCn1MVWqR2"){
              return Products_List_Admin();
            }
            else if(snapshot.hasData &&(FirebaseAuth.instance.currentUser?.uid).toString() == "OMCkaR8mdxNDmDE1O7gkFFd9HyX2"){
              return scanInovice();
            }
            return WelcomePage();
          },
        ),
      );
}
