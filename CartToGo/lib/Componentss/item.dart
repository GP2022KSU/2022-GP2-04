class ShoppingItem {
  String? id;
  String? productName;
  bool isBuyed;
  static List<ShoppingItem> Shoppingitems = [];
  ShoppingItem({
    required this.id,
    required this.productName,
    this.isBuyed = false,
  });

  factory ShoppingItem.fromMap(Map<dynamic, dynamic> map) {
    return ShoppingItem(
      id: map['ItemID'] ?? '',
      productName: map['productName'] ?? '',
      isBuyed: map['isBuyed'] == true ? true : false,
    );
  }
}
