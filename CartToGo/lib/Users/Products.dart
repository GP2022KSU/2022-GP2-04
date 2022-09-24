import 'package:firebase_database/firebase_database.dart';

class Product {
  final String Name;
  final String Brand;
  final String Category;
  final double Price;
  final String Size;
  final String Barcode;
  final String Location;

  const Product({
    required this.Name,
    required this.Brand,
    required this.Category,
    required this.Price,
    required this.Size,
    required this.Barcode,
    required this.Location,
  });

  //
  factory Product.fromMap(Map<dynamic, dynamic> map) {
    return Product(
      Name: map['Name:'] ?? '',
      Brand: map['Brand:'] ?? '',
      Category: map['Category'] ?? '',
      Price: map['Price:'] ?? '',
      Size: map['Size:'] ?? '',
      Barcode: map['Barcode:'] ?? '',
      Location: map['Location:'] ?? '',
    );
  }
}
