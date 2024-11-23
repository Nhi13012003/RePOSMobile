import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/dish.dart';
class DishAPI {
  Future<List<Dish>> fetchDishes (String dishType) async {
    String url ='';
    if(dishType == 'all')
      {
        url = 'http://localhost:3000/api/dish/';
      }
    else url = 'http://localhost:3000/api/dish/type/$dishType';
    final uri = Uri.parse(url);
    final response =await  http.get(uri);
    final body = response.body;
    final json = jsonDecode(body) as List<dynamic>;
    final dish  = json.map((item) => Dish.fromJson(item)).toList();
    return dish;
  }

  Future<List<Dish>> searchDishes(String query) async {
    final allDishes = await fetchDishes('all');
    return allDishes.where((dish) => dish.name.toLowerCase().contains(query.toLowerCase())).toList();
  }
  Future<Dish> fetDishById(String id) async {
    final url = 'http://localhost:3000/api/dish/$id';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final dish = Dish.fromJson(json);
    return dish;
  }
}