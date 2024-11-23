class Rating {
  String? id;
  int ratingStar;
  String dishID;
  String clientID;
  DateTime? createAt;
  DateTime? updateAt;

  Rating({
    this.id,
    required this.ratingStar,
    required this.dishID,
    required this.clientID,
    this.createAt,
    this.updateAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      ratingStar: json['ratingStar'].toInt(),
      dishID: json['dishID'],
      clientID: json['clientID'],
      createAt: DateTime.parse(json['createAt']),
      updateAt: DateTime.parse(json['updateAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ratingStar': ratingStar,
      'dishID': dishID,
      'clientID': clientID,
    };
  }
}
