import 'package:firebase_database/firebase_database.dart';

class Product {
  String name = '';
  String size = '';
  String price = '';
  String quantity;
  Product({
    required this.name,
    required this.size,
    required this.price,
    required this.quantity,
  });
  //Product.fromSnapshot(DataSnapshot snapshot)

}
