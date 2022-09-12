// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carttogo/Pages/loyaltyCard.dart';
import 'package:flutter/material.dart';
import 'package:carttogo/Pages/Navigation.dart';

class CartInstructions extends StatefulWidget {
  const CartInstructions({Key? key}) : super(key: key);

  @override
  State<CartInstructions> createState() => _CartInstructionsState();
}

class _CartInstructionsState extends State<CartInstructions> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        //color: Colors.black,
        child: Stack(children: [
          Positioned(
            top: 40,
            left: 20,
            child: Material(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(0.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: Offset(-10.0, 10.0),
                      blurRadius: 20,
                      spreadRadius: 4,
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 33,
            child: Card(
              elevation: 10,
              shadowColor: Colors.grey.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Color.fromARGB(255, 35, 61, 255),
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: AssetImage("assets/images/HandQR.png"),
                      ))),
            ),
          ),
          Positioned(
            top: 60,
            right: 190,
            child: Container(
              //color: Colors.black,
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.4,
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "لبدأ التسوق",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Divider(
                        color: Colors.black12,
                        endIndent: 20,
                      ),
                      Text(
                        "مرر بطاقة الولاء",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
                          color: Color.fromARGB(255, 42, 41, 41),
                        ),
                      ),
                      Text(
                        "الخاصة بك الى",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
                          color: Color.fromARGB(255, 42, 41, 41),
                        ),
                      ),
                      Text(
                        "  السلة لربطها",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
                          color: Color.fromARGB(255, 42, 41, 41),
                        ),
                      ),
                      Text(
                        "  بسلتك الذكية",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
                          color: Color.fromARGB(255, 42, 41, 41),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ]),
              ),
            ),
          ),
          Positioned(
            top: 250,
            left: 45,
            child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    NaviState().Myindex = 1;
                    print(NaviState().Myindex);
                    return Navi();
                  }));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.35,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 35, 61, 255),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: Offset(-10, 10),
                        blurRadius: 20,
                        spreadRadius: 4,
                      )
                    ],
                  ),
                  child: Text(
                    "مسح",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                )),
          ),
        ]));
  }
}
