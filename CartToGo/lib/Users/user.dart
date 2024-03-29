library carttogo.globals;

import 'dart:async';
import 'dart:core';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Pages/Product.dart';
import 'package:carttogo/Componentss/WishListItems.dart';

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

bool ConnectedToCart = false;

bool getConnectedToCart() {
  BringConnectedToCart();
  return ConnectedToCart;
}

Future<bool> BringConnectedToCart() async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child(
            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/CartsStatus/ConnectedToCart")
        .get();
    ConnectedToCart = await snapshot.value == true ? true : false;

    return ConnectedToCart;
  }
  return ConnectedToCart;
}

Future<String> BringLoyaltyCardID() async {
  if (FirebaseAuth.instance.currentUser != null) {
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

Future<int> BringPaidCarts() async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child(
            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/CartsStatus/PaidCarts")
        .get();
    PaidCarts = int.parse(snapshot.value.toString());
    return PaidCarts;
  }
  return PaidCarts;
}

Future<int> BringLastCartNumber() async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child(
            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/CartsStatus/FutureCartNumber")
        .get();

    LastCartNumber = await (int.parse(snapshot.value.toString())) - 1;
    return LastCartNumber;
  }
  return 0;
}

Future<int> BringNumOfProducts() async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child(
            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/CartsStatus/NumOfProducts")
        .get();
    numOfProducts = await (int.parse(snapshot.value.toString()));
    return numOfProducts;
  }
  return 0;
}

Future<int> BringNumberOfOffers() async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("Products").get();
    final product = snapshot.value as Map<dynamic, dynamic>;
    product.forEach((key, value) {
      if (value['Offer'] == true) {
        countOffers++;
      }
    });

    return countOffers;
  }
  return countOffers;
}

int getNumofOffer() {
  BringNumberOfOffers();
  return countOffers;
}

Future<List<String>> BringNames() async {
  names = [];
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("Products").get();
    final map = snapshot.value as Map<dynamic, dynamic>;
    map.forEach((key, value) {
      final product = Product.fromMap(value);
      names.add(product.Name.toString() +
          " " +
          product.Brand.toString() +
          " | " +
          product.Location.toString() +
          " | الكمية: " +
          product.Quantity.toString());
    });
    return names;
  }
  return names;
}

Future<List<String>> BringhistoryPurch() async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child(
            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/${getLastCartNum()}")
        .orderByPriority()
        .limitToFirst(getnumOfProducts())
        .get();
    final map = snapshot.value as Map<dynamic, dynamic>;
    DatabaseReference ref7 = FirebaseDatabase.instance.ref(
        "Shopper/${FirebaseAuth.instance.currentUser?.uid}/PurchaseHistory");
    map.forEach((key, value) async {
      final product = Product.fromMap(value);

      String barcode = value['Barcode'];
      String subca = value['SubCategory'];
      double price = value['Price'];
      await ref7.push().update({
        "SubCategory": subca,
        "Price": price,
      });
    });
    return names;
  }
  return names;
}

Future<Map<dynamic, dynamic>> BringPurchaseHistory() async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child(
            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/PurchaseHistory")
        .get();
    final map = snapshot.value as Map<dynamic, dynamic>;
    Purchasehis = map;
    return Purchasehis;
  }
  return "" as Map<dynamic, dynamic>;
}

Future<Map<dynamic, dynamic>> bringAllProducts() async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("Products").get();
    final map = snapshot.value as Map<dynamic, dynamic>;
    allProducts = map;
    return allProducts;
  }
  return allProducts;
}

Future<List<String>> BringRecommendProducts(String RecProduct) async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("Products").get();
    final map = snapshot.value as Map<dynamic, dynamic>;
    RecommendPro = [];
    map.forEach((key, value) {
      final product = Product.fromMap(value);
      if (product.Subcategory.toString() == RecProduct) {
        RecommendPro.add(product.Barcode.toString());
      } else {}
    });

    return RecommendPro;
  }
  return " " as List<String>;
}

//admin

//admin search to edit or delete
Future<List<String>> BringProducts() async {
  barcodes = [];
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("Products").get();
    final map = snapshot.value as Map<dynamic, dynamic>;
    map.forEach((key, value) {
      final product = Product.fromMap(value);
      barcodes.add(product.SearchBarcode.toString() +
          " | " +
          product.Name.toString() +
          " " +
          product.Brand.toString());
    });

    return barcodes;
  }
  return barcodes;
}

Future<WishProduct> BringProductInfo(String barcode) async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child("Products/$barcode").get();
  final map = snapshot.value as Map<dynamic, dynamic>;
  final product = WishProduct.fromMap(map);
  return product;
}

//-----------Brings the quantity of the deleted product-----------//
Future<int> BringProductQuantity(int barcode) async {
  final _quanData =
      FirebaseDatabase.instance.ref("Products/${barcode.toString()}/Quantity");
  final snapshot = await _quanData.get();
  if (snapshot.exists) {
    quan = (int.parse(snapshot.value.toString()));
    return (int.parse(snapshot.value.toString()));
  } else {}
  return 0;
}

int quan = 0;
int getProductQuantity(String barcode) {
  BringProductQuantity(int.parse(barcode));
  return quan;
}

Future<double> BringTotalPrice() async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child(
            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/CartsStatus/Total")
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
            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/${getLastCartNum()}/CartInfo/Paid")
        .get();
    if (snapshot.value.toString() == "true") {
      Paid = true;
    }
    return Paid;
  }
  return Paid;
}

Future<double> BringTotalInsideCart() async {
  if (FirebaseAuth.instance.currentUser != null) {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child(
            "Shopper/${FirebaseAuth.instance.currentUser?.uid}/Carts/${getLastCartNum()}/CartInfo/Total")
        .get();
    TotalInsideCart = await (double.parse(snapshot.value.toString()));
    return TotalInsideCart;
  }
  return TotalInsideCart;
}

double totalPriceAfterPoints() {
  double eachPointinRiyal = 0.1;
  double PointinRiyal = 0;
  double NewTotal = 0;
  if (getPoints() > 0) {
    for (var i = 0; i < getPoints(); i++) {
      PointinRiyal += eachPointinRiyal;
    }
    String inString = PointinRiyal.toStringAsFixed(2);
    PointinRiyal = double.parse(inString);
    Total = getTotal();
    NewTotal = Total - PointinRiyal;
    inString = NewTotal.toStringAsFixed(2);
    NewTotal = double.parse(inString);
    return NewTotal;
  }

  return NewTotal;
}

double getTotalInCart() {
  BringTotalInsideCart();
  return TotalInsideCart;
}

String getLoyaltyCardID() {
  if (_L1 == 0) {
    BringLoyaltyCardID();
    _L1++;
  }
  return LoyaltyCardID;
}

double getTotalAfterPoints() {
  totalPriceAfterPoints();
  TotalAfterPoints = totalPriceAfterPoints();
  return TotalAfterPoints;
}

int getLastCartNum() {
  BringLastCartNumber();
  return LastCartNumber;
}

int getPaidCarts() {
  BringPaidCarts();
  return PaidCarts;
}

String getUsername() {
  if (_U1 == 0) {
    BirngUsername();
    _U1++;
  }
  return Username;
}

Map<dynamic, dynamic> getPurchaseHistory() {
  BringPurchaseHistory();
  return Purchasehis;
}

Map<dynamic, dynamic> getAllProducts() {
  bringAllProducts();
  return allProducts;
}

List<String> getNames() {
  BringNames();
  return names;
}

List<String> getRecomProducts(String Reco) {
  BringRecommendProducts(Reco);
  return RecommendPro;
}

//admin
List<String> getBarcode() {
  BringProducts();
  return barcodes;
}

List<String> getBringhistoryPurch() {
  BringhistoryPurch();
  return barcodes;
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
double TotalAfterPoints = 0.0;
double TotalInsideCart = 0.0;
int PointsAfterPaying = 0;
int PaidCarts = 0;
bool Paid = false;
List<String> names = [];
List<String> barcodes = [];
List<String> RecommendPro = [];
late Map<dynamic, dynamic> Purchasehis = {};
late Map<dynamic, dynamic> allProducts = {};
int countOffers = 0;
