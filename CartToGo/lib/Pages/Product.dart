class Product {
  final String Name;

  /*final String Brand;
  final String Category;
  final String Price;
  final String Quantity;
  final String Size;
  final String Barcode;
*/
  
  const Product({
    required this.Name,
    /*required this.Brand,
    required this.Category,
    required this.Price,
    required this.Quantity,
    required this.Size,
    required this.Barcode,*/
  });

  factory Product.fromMap(Map<dynamic, dynamic> map) {
    return Product(
      Name: map['Name'] ?? '',
     /* Brand: map['Brand'] ?? '',
      Category: map['Category'] ?? '',
      Price: map['Price'] ?? '',
      Quantity: map['Quantity'] ?? '',
      Size: map['Size'] ?? '',
      Barcode: map['Barcode'] ?? '',*/
    );
  }

}

/*
class User {

  final String name;
  final String phoneNumber;

  const User({
    required this.name,
    required this.phoneNumber,
  });

  factory User.fromMap(Map<dynamic, dynamic> map) {
    return User(
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }
}
class Product {
  String name , brand , category, price, quantity, size , barcode;

  Product(this.name,this.brand,this.category,this.price,this.quantity,this.size,this.barcode);
}
*/
