class Product {
  final String name;
  final String size;
  final String price;
  String quantity;
  Product({
    required this.name,
    required this.size,
    required this.price,
    required this.quantity,
  });
/*
  factory Product.fromRTDB(Map<String, dynamic> data) {
    return Product(
      name: data['Name'] ?? 'null',
      size: data['Size'] ?? '0',
      price: data["Price"] ?? "0.0",
    );
  }
  */
}
