import 'dart:convert';

import 'package:client_restaurant/models/dishType.dart';
import 'package:http/http.dart' as http;
class DishTypeAPI {
  Future<List<DishType>> fetchDishTypes () async {
    const url = 'http://localhost:3000/api/dishType/';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final result = json['dishTypes'] as List<dynamic>;
    final dishTypes = result.map((item) => DishType.fromJson(item)).toList();
    return dishTypes;
  }
  Future<DishType> fetchDishTypeWithId(String dishTypeId) async {
    final url = 'http://localhost:3000/api/dishType/$dishTypeId';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    return DishType.fromJson(json);
  }

}