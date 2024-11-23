class Images {
  String id;
  String dishId;
  String Link;
  DateTime createAt;

  Images({
    required this.id,
    required this.dishId,
    required this.Link,
    required this.createAt,
  });

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      id: json['id'],
      dishId: json['dishId'],
      Link: json['Link'],
      createAt: DateTime.parse(json['createAt']),
    );
  }
}