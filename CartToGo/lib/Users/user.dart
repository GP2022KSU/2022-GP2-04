library carttogo.globals;
import 'package:firebase_database/firebase_database.dart';
  String userid = "Stu2LFiw98aJfRWU445Tw73oYnD3";
  /*
void main(){
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
*/
  Future<String> _BringLoyaltyCardID(String userID) async{
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("Shopper/$userID/LoyaltyCardID").get();
     final data=await snapshot.value.toString();
    LoyaltyCardID=await data;
      return data;
      print("Data: "+LoyaltyCardID);
    
  }
   Future<String> _BirngUsername(String userID) async{
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("Shopper/$userID/Username").get();
     return Username= snapshot.value.toString();
    
  }

     Future<int> _BringPoints(String userID) async{
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child("Shopper/$userID/Points").get();
        return points= int.parse(snapshot.value.toString());
    }
String getLoyaltyCardID(){
_BringLoyaltyCardID(userid);
return LoyaltyCardID;
}

String getUsername() {
  _BirngUsername(userid);
  return Username;
}

int getPoints() {
  _BringPoints(userid);
  return points;
}
int points = 0;
String Username="";
String LoyaltyCardID="";