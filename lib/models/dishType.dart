class DishType {
  String id;
  String DishTypeName;
  String DishTypeDescription;

  DishType({required this.id, required this.DishTypeName, required this.DishTypeDescription});

  factory DishType.fromJson(Map<String, dynamic> json) {
    return DishType(
      id: json['id'],
      DishTypeName: json['DishTypeName'],
      DishTypeDescription: json['DishTypeDescription'],
    );
  }
}