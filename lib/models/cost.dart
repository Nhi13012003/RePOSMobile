class Costs {
  String id;
  String dishId;
  int cost;
  DateTime createAt;

  Costs({
    required this.id,
    required this.dishId,
    required this.cost,
    required this.createAt,
  });

  factory Costs.fromJson(Map<String, dynamic> json) {
    return Costs(
      id: json['id'],
      dishId: json['dishId'],
      cost: json['cost'],
      createAt: DateTime.parse(json['createAt']),
    );
  }
}