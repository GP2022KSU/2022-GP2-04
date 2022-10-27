class ShoppingItem {
  String? id;
  String? productName;
  bool isBuyed;

  ShoppingItem({
    required this.id,
    required this.productName,
    this.isBuyed = false,
  });

  static List<ShoppingItem> shoppingList() {
    return [];
  }
}
