class userData {
  final String CardID;
  final String Points;
  final String Username;

  userData({required this.CardID,required this.Points,required this.Username});

  String getCardID(){
    return CardID;
  }
  factory userData.fromRTDB(Map<String, dynamic> data){
    return userData(
      CardID: data['LoyaltyCardID'] ?? 'null',
      Points: data['Points'] ?? '0',
      Username: data["Username"] ?? "0.0",

    );
  }
}
