import 'package:carttogo/Pages/welcomePage.dart';
import 'package:carttogo/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:carttogo/widgets/cardHistory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carttogo/Users/user.dart' as user;
import 'package:flip_card/flip_card.dart';

class LoyaltyCard extends StatelessWidget {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
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

  //logout dialog, to ensure that the shopper want to log out or not
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
                    backgroundColor: const Color(0xffffffff),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const SizedBox(height: 15),
                      const Text(
                        "هل تريد تسجيل الخروج؟",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Divider(
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
                                        builder: (context) =>
                                            const WelcomePage()));
                              },
                              child: const Center(
                                  child: Text("خروج",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Color(0xFFFE4A49),
                                        fontWeight: FontWeight.bold,
                                      ))))),
                      const Divider(
                        height: 1,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: InkWell(
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(15.0),
                                  bottomRight: Radius.circular(15.0)),
                              highlightColor: Colors.grey[200],
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: const Center(
                                  child: Text("إلغاء",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
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
                child: FlipCard(
                  fill: Fill
                      .fillBack, // Fill the back side of the card to make in the same size as the front.
                  direction: FlipDirection.HORIZONTAL, // default
                  front: CardWidget(),
                  back: Container(
                    child: CardsBack(context),
                  ),
                )),
            Center(
              heightFactor: 1.04,
              child: Column(
                children: [
                  const Text(
                    "الفواتير السابقة", // name of the product
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'CartToGo',
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  Cardhistory(),
                ],
              ),
            ),
          ])
        ]));
  }

  // When flipping the card, the collect/redeem points policy is shown
  Widget CardsBack(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.94,
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 37, 9, 179),
              Color.fromARGB(255, 63, 60, 255)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            const BoxShadow(
                color: Color.fromARGB(62, 129, 129, 129),
                offset: Offset(8, 8),
                blurRadius: 25)
          ],
          image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  const Color.fromARGB(255, 37, 9, 179).withOpacity(0.2),
                  BlendMode.dstATop),
              image: const AssetImage('assets/images/Cart21.png'),
              fit: BoxFit.fitWidth),
        ),
        child: Column(children: const [
          SizedBox(
            height: 70,
          ),
          Text(
            "لكل 100 ريال تنفقها = تحصل على 10 نقاط",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: <Shadow>[
                  Shadow(
                      color: Colors.black,
                      offset: Offset(-5.0, 5.0),
                      blurRadius: 15)
                ]),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "لكل 10 نقاط تستبدلها = تحصل على 1 ريال",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: <Shadow>[
                  Shadow(
                      color: Colors.black,
                      offset: Offset(-5.0, 5.0),
                      blurRadius: 15)
                ]),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: EdgeInsets.only(right: 300),
            child: Icon(
              Icons.flip_to_front,
              size: 30,
              color: Colors.white,
            ),
          ),
        ]));
  }
}
