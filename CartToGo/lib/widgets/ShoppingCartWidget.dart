import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:async';
import 'package:carttogo/Users/user.dart' as user;

class ShoppingCartWidget extends StatefulWidget {
  const ShoppingCartWidget({Key? key}) : super(key: key);

  @override
  State<ShoppingCartWidget> createState() => _ShoppingCartWidgetState();
}

class _ShoppingCartWidgetState extends State<ShoppingCartWidget> {
  late int LastCartNumber = 0;
  final _database = FirebaseDatabase.instance.ref();
  late StreamSubscription _streamSubscription;
  String userid = "Stu2LFiw98aJfRWU445Tw73oYnD3"; //Change to real id
  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  void _activateListeners() {
    _streamSubscription = _database
        .child("Shopper/$userid/Carts/LastCartNumber")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      setState(() {
        LastCartNumber = (int.parse(data.toString()) - 1);
        print(LastCartNumber);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final fb = FirebaseDatabase.instance;
    var l;
    var g;
    final ref = fb
        .ref()
        .child('Shopper/$userid/Carts/' + user.getLastCartNumber().toString());
    return Scaffold(
      body: FirebaseAnimatedList(
        query: ref,
        shrinkWrap: true,
        itemBuilder: (context, snapshot, animation, index) {
          var v =
              snapshot.value.toString(); // {subtitle: webfun, title: subscribe}

          g = v.replaceAll(
              RegExp("{|}|subtitle: |title: "), ""); // webfun, subscribe
          g.trim();

          l = g.split(','); // [webfun,  subscribe}]

          return GestureDetector(
            onTap: () {
              var c = snapshot.value.toString();
              print(c);
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: Colors.indigo[100],
                  /*
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red[900],
                    ),
                    onPressed: () {
                      ref.child(snapshot.key!).remove();
                    },
                  ),
                  */
                  title: Text(
                    l[0],
                    // 'dd',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    l[0],
                    // 'dd',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void deactivate() {
    _streamSubscription.cancel();
    super.deactivate();
  }
/*
  void _BringLastCartNumber(String userID) async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot =
        await ref.child("Shopper/$userID/Carts/LastCartNumber").get();
    LastCartNumber = await (int.parse(snapshot.value.toString()) - 1);
    print("Last Cart Number: $LastCartNumber");
    //return data;
  }
  */
}
