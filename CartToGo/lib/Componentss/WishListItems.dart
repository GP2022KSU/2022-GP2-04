class WishProduct {
  final String Name; //
  final String Brand; //
  final String Category; //
  final double Price; //
  final String Size; //
  final String Barcode; //
  final String Subcategory; //
  final String ImgUrl; //
  final bool Offer; //
  final double PriceAfterOffer; //

  const WishProduct(
      {required this.Name,
      required this.Brand,
      required this.Category,
      required this.Price,
      required this.Size,
      required this.Barcode,
      required this.Subcategory,
      required this.ImgUrl,
      required this.Offer,
      required this.PriceAfterOffer});

  //
  factory WishProduct.fromMap(Map<dynamic, dynamic> map) {
    return WishProduct(
      Name: map['Name'] ?? '',
      Brand: map['Brand'] ?? '',
      Category: map['Category'] ?? '',
      Price: double.parse(map['Price'].toString()),
      PriceAfterOffer: double.parse(map['PriceAfterOffer'].toString()),
      Size: map['Size'] ?? '',
      Barcode: map['Barcode'].toString(),
      Subcategory: map['SubCategory'].toString(),
      ImgUrl: map['ImgUrl'].toString(),
      Offer: map['Offer'] == true ? true : false,
    );
  }
}
