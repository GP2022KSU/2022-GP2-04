import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'Pages/LoyaltyCard.dart';
import 'Pages/ShoppingCart.dart';
import 'package:google_fonts/google_fonts.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<CurvedNavigationBarState> _NavKey = GlobalKey();
  var Pages = [ShoppingCart(), LoyaltyCard()];
  var Myindex = 0;
  var _title = ["سلة التسوق", "بطاقة الولاء"];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top:false,
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white24,
        title: Text(
          _title[Myindex],
          style: GoogleFonts.inter(
            textStyle: TextStyle(color: Colors.black,
            fontWeight: FontWeight.w800,
            //Directionality(
              //textDirection: Text.Direction.rtl,
              //),//Directionality
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _NavKey,
        items: [Icon(Icons.shopping_cart_outlined,size:30,color: Myindex == 0 ? Color.fromARGB(255, 35, 61, 255) : Colors.white), 
        Icon(Icons.credit_card,size:30,color: Myindex == 1 ? Color.fromARGB(255, 35, 61, 255) : Colors.white)],
        backgroundColor: Colors.white24,
        buttonBackgroundColor: Colors.white24,
        height: 55,
        onTap: (index) {
          setState(() {
            Myindex = index;
          });
        },
        animationCurve: Curves.fastLinearToSlowEaseIn,
        animationDuration: Duration(milliseconds: 400),
        color: Color.fromARGB(255, 35, 61, 255),
        ),
      body: Pages[Myindex],
      ),
    );
  }
}
