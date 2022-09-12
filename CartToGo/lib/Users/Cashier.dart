library carttogo.globals;

import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

final bool check = false;
void main() {}
String uid = "";
String Username = "";
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

String getUID(String qrid) {
  BringUID(qrid);
  return uid;
}

String getUsername(String id) {
  BirngUsername(id);
  return Username;
}
