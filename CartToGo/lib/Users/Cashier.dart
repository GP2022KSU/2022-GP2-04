library carttogo.globals;

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

final bool check = false;
String uid = "";
String Username = "";
int numOfProducts = 0;
double Total = 0.0;
double TotalAfterPoints = 0.0;

Future<String> BringUID(String QRId) async {
  if (FirebaseAuth.instance.currentUser != null) {
    print(FirebaseAuth.instance.currentUser?.uid);

    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("QRUidFinder/${QRId}/shopperID").get();
    final data = await snapshot.value.toString();
    uid = await data;
    return uid;
  }
  return uid;
}

Future<String> BirngUsername(String uid1) async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("Shopper/${uid1}/Username").get();
    return Username = snapshot.value.toString();
  }
  return Username;
}

Future<int> BringNumOfProducts(String uid2) async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot =
        await ref.child("Shopper/${uid2}/Carts/NumOfProducts").get();
    numOfProducts = await (int.parse(snapshot.value.toString()));
    return numOfProducts;
  }
  return numOfProducts;
}

/*
Future<double> BringTotalPrice(String uid3, int cartNumber) async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child("Shopper/${uid3}/Carts/${cartNumber.toString()}/Total")
        .get();
    Total = await (double.parse(snapshot.value.toString()));
    return Total;
  }
  return Total;
}
*/
Future<double> BringTotalAfterPoints(String uid3, int cartNumber) async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot =
        await ref.child("Shopper/${uid3}/Carts/TotalAfterPoints").get();
    TotalAfterPoints = await (double.parse(snapshot.value.toString()));
    return TotalAfterPoints;
  }
  return TotalAfterPoints;
}

String getUID(String qrid) {
  BringUID(qrid);
  return uid;
}

String getUsername(String id) {
  BirngUsername(id);
  return Username;
}

int getnumOfProducts(String id1) {
  BringNumOfProducts(id1);
  return numOfProducts;
}

/*
double getTotal(String id2, int cartNum) {
  BringTotalPrice(id2, cartNum);
  return Total;
}
*/
double getTotalAfterPoints(String id2, int cartNum) {
  BringTotalAfterPoints(id2, cartNum);
  return TotalAfterPoints;
}
