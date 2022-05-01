library carttogo.globals;

import 'package:firebase_database/firebase_database.dart';

String userid = "Stu2LFiw98aJfRWU445Tw73oYnD3";

void main() {
  DatabaseReference starCountRef =
      FirebaseDatabase.instance.ref("Shopper/$userid/LoyaltyCardID");
  starCountRef.onValue.listen((DatabaseEvent event) {
    final LoyaltyCardID = event.snapshot.value;
  });

  DatabaseReference starCountRef1 =
      FirebaseDatabase.instance.ref("Shopper/$userid/Username");
  starCountRef1.onValue.listen((DatabaseEvent event) {
    final Username = event.snapshot.value;
  });

  DatabaseReference starCountRef2 =
      FirebaseDatabase.instance.ref("Shopper/$userid/Points");
  starCountRef2.onValue.listen((DatabaseEvent event) {
    final points = event.snapshot.value;
  });
}

Future<String> _BringLoyaltyCardID(String userID) async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child("Shopper/$userID/LoyaltyCardID").get();
  final data = await snapshot.value.toString();
  LoyaltyCardID = await data;
  return data;
}

Future<String> _BirngUsername(String userID) async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child("Shopper/$userID/Username").get();
  return Username = snapshot.value.toString();
}

Future<int> _BringPoints(String userID) async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child("Shopper/$userID/Points").get();
  return points = int.parse(snapshot.value.toString());
}

Future<int> _BringLastCartNumber(String userID) async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot =
      await ref.child("Shopper/$userID/Carts/LastCartNumber").get();
  print("Last Cart Number: $LastCartNumber");
  LastCartNumber = await (int.parse(snapshot.value.toString()) - 1);
  return LastCartNumber;
  //return data;
}

String getLoyaltyCardID() {
  if (_L1 == 0) {
    _BringLoyaltyCardID(userid);
    _L1++;
  }
  return LoyaltyCardID;
}

String getUsername() {
  if (_U1 == 0) {
    _BirngUsername(userid);
    _U1++;
  }
  return Username;
}

int getPoints() {
  if (_P1 == 0) {
    _BringPoints(userid);
    _P1++;
  }
  return points;
}

int getLastCartNumber() {
  if (_C1 == 0) {
    _BringLastCartNumber(userid);
    print("heresss: $LastCartNumber");
    _C1++;
  }
  return LastCartNumber;
}

int _L1 = 0;
int _U1 = 0;
int _P1 = 0;
int _C1 = 0;
int points = 0;
int LastCartNumber = 0;
String Username = "";
String LoyaltyCardID = "";
