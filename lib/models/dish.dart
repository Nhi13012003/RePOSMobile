import 'cost.dart';
import 'image.dart';

class Dish {
  String id;
  String name;
  String description;
  String dishType;
  List<Costs>? costs;
  List<Images>? images; // Use dynamic for images

  Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.dishType,
    this.costs, // Make costs and images optional in the constructor
    this.images,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      dishType: json['dishType'],
      costs: json['costs'] != null
          ? (json['costs'] as List).map((e) => Costs.fromJson(e)).toList()
          : null, // Conditional assignment for costs
      images: json['images'] != null
          ? (json['images'] as List).map((e) => Images.fromJson(e)).toList()
          : null, // Conditional assignment for images
    );
  }
}