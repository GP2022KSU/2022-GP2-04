library carttogo.globals;

import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Pages/Product.dart';

final bool check = false;
void main() {
  DatabaseReference starCountRef = FirebaseDatabase.instance
      .ref("Shopper/${FirebaseAuth.instance.currentUser?.uid}/LoyaltyCardID");
  starCountRef.onValue.listen((DatabaseEvent event) {
    final LoyaltyCardID = event.snapshot.value;
  });

  DatabaseReference starCountRef1 = FirebaseDatabase.instance
      .ref("Shopper/${FirebaseAuth.instance.currentUser?.uid}/Username");
  starCountRef1.onValue.listen((DatabaseEvent event) {
    final Username = event.snapshot.value;
  });

  DatabaseReference starCountRef2 = FirebaseDatabase.instance
      .ref("Shopper/${FirebaseAuth.instance.currentUser?.uid}/Points");
  starCountRef2.onValue.listen((DatabaseEvent event) {
    final points = event.snapshot.value;
  });
}

Future<String> BringLoyaltyCardID() async {
  if (FirebaseAuth.instance.currentUser != null) {
    print(FirebaseAuth.instance.currentUser?.uid);

    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child(
            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/LoyaltyCardID")
        .get();
    final data = await snapshot.value.toString();
    LoyaltyCardID = await data;
    return data;
  }
  return "";
}

Future<String> BirngUsername() async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child("Shopper/${FirebaseAuth.instance.currentUser?.uid}/Username")
        .get();
    return Username = snapshot.value.toString();
  }
  return "";
}

Future<int> BringPoints() async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child("Shopper/${FirebaseAuth.instance.currentUser?.uid}/Points")
        .get();
    return points = int.parse(snapshot.value.toString());
  }
  return 0;
}

Future<int> BringLastCartNumber() async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child(
            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/FutureCartNumber")
        .get();
    print("Last Cart Number: $LastCartNumber");
    LastCartNumber = await (int.parse(snapshot.value.toString())) - 1;
    return LastCartNumber;
  }
  return 0;
}

Future<int> BringnumOfObtPoints() async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child(
            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/PointsHistory/numOfObtPoints/")
        .get();
    numOfObtPoints = (int.parse(snapshot.value.toString()));
    return numOfObtPoints;
  }
  return 0;
}

Future<int> BringNumOfProducts() async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child(
            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/NumOfProducts")
        .get();
    print("Last Cart Number: $LastCartNumber");
    numOfProducts = await (int.parse(snapshot.value.toString()));
    return numOfProducts;
  }
  return 0;
}

Future<List<String>> BringProducts() async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("Products").get();
    //print(snapshot.value.toString());
    final map = snapshot.value as Map<dynamic, dynamic>;
    map.forEach((key, value) {
      final product = Product.fromMap(value);
      names.add(product.Name.toString());
    });
    print(names);
    return names;
  }
  return names;
}

Future<double> BringTotalPrice() async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child("Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/Total")
        .get();
    Total = await (double.parse(snapshot.value.toString()));
    return Total;
  }
  return 0;
}

Future<bool> BringPaid() async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child(
            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/${getLastCartNum()}/Paid")
        .get();
    if (snapshot.value.toString() == "true") {
      Paid = true;
      print("Paid" + Paid.toString());
    }
    return Paid;
  }
  return Paid;
}

String getLoyaltyCardID() {
  if (_L1 == 0) {
    BringLoyaltyCardID();
    _L1++;
  }
  return LoyaltyCardID;
}

int getLastCartNum() {
  BringLastCartNumber();
  return LastCartNumber;
}

String getUsername() {
  if (_U1 == 0) {
    BirngUsername();
    _U1++;
  }
  return Username;
}

List<String> getProducts() {
  BringProducts();
  return names;
}

int getPoints() {
  if (_P1 == 0) {
    BringPoints();
    _P1++;
  }
  return points;
}

int getnumOfProducts() {
  BringNumOfProducts();
  return numOfProducts;
}

int getnumOfObtPoints() {
  BringnumOfObtPoints();
  return numOfObtPoints;
}

double getTotal() {
  BringTotalPrice();
  return Total;
}

bool getPaid() {
  BringPaid();
  return Paid;
}

/*
int getLastCartNumber() {
  if (_C1 == 0) {
    BringLastCartNumber(userid);
    print("heresss: $LastCartNumber");
    _C1++;
  }
  return LastCartNumber;
}
*/
int _L1 = 0;
int _U1 = 0;
int _P1 = 0;
int _C1 = 0;
int points = 0;
int LastCartNumber = 0;
String Username = "";
String LoyaltyCardID = "";
int numOfProducts = 0;
int numOfObtPoints = 0;
double Total = 0.0;
bool Paid = false;
List<String> names = [];
