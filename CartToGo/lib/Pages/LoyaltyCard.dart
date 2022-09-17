import 'package:carttogo/Pages/welcomePage.dart';
import 'package:carttogo/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:carttogo/widgets/cardHistory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carttogo/Users/user.dart' as user;

class LoyaltyCard extends StatelessWidget {
  String checkPointText() {
    if (user.getPoints() == 2) {
      return "نقطتان";
    }
    if (user.getPoints() >= 3 && CardWidgetState().points < 10) {
      print("Here");
      return "نقاط";
    }
    return "نقطة";
  }

  @override
  Widget build(BuildContext context) {
    void _showMyDialog() async {
      return showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return Directionality(
                textDirection: TextDirection.rtl,
                child: Dialog(
                    elevation: 0,
                    backgroundColor: Color(0xffffffff),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      SizedBox(height: 15),
                      Text(
                        "هل تريد تسجيل الخروج؟",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: InkWell(
                              highlightColor: Colors.grey[200],
                              onTap: () async {
                                await FirebaseAuth.instance.signOut();
                                print(
                                    "UID: ${FirebaseAuth.instance.currentUser?.uid}");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WelcomePage()));
                              },
                              child: Center(
                                  child: Text("خروج",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Color(0xFFFE4A49),
                                        fontWeight: FontWeight.bold,
                                      ))))),
                      Divider(
                        height: 1,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: InkWell(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15.0),
                                  bottomRight: Radius.circular(15.0)),
                              highlightColor: Colors.grey[200],
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Center(
                                  child: Text("إلغاء",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                      )))))
                    ])));
          });
    }

    return Scaffold(
        backgroundColor: Colors.white24,
        appBar: AppBar(
          backgroundColor: Colors.white24,
          title: const Text("بطاقة الولاء",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'CartToGo',
              )),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(3),
                        textStyle: MaterialStateProperty.all(const TextStyle(
                            fontSize: 14,
                            fontFamily: 'CartToGo',
                            fontWeight: FontWeight.bold)),
                        fixedSize:
                            MaterialStateProperty.all(const Size(70, 10)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    onPressed: () async {
                      _showMyDialog();
                    },
                    child: const Text('خروج')))
          ],
          centerTitle: true,
          elevation: 0,
        ),
        body: ListView(children: <Widget>[
          Column(children: <Widget>[
            Center(
              heightFactor: 1,
              child: CardWidget(),
            ),
            Center(
              heightFactor: 1.04,
              child: Cardhistory(),
            )
          ])
        ]));
  }
}
