import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/rating.dart';


class RatingAPI {
  Future<List<Rating>> fetchRatingsWithDishId(String dishId) async {
    try {
      final url = 'http://localhost:3000/api/rating/dish/$dishId';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final body = response.body;
      final json = jsonDecode(body) as List<dynamic>;
      final ratings  = json.map((item) => Rating.fromJson(item)).toList();
      return ratings;
    } on Exception catch (e) {
      print(e);
      return [];
    }
  }
  Future<void> createRating(Rating rating) async {
    final url = 'http://localhost:3000/api/rating/';
    final body = rating.toJson();
    final uri = Uri.parse(url);
    print(body);
    final response = await http.post(uri, body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'}, // Thêm header Content-Type
    );
    print(response.body);
    if (response.statusCode == 201) {
      print('Rating created successfully');
    } else {
      throw Exception('Failed to create rating: ${response.statusCode}');
    }
  }
}