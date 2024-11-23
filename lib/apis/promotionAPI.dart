import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/promotion.dart';

class PromotionAPI {
  Future<void> fetchPromotions () async {
    final url = Uri.parse('http://localhost:3000/promotion');
    final response = await http.get(url);
    final body = response.body;
    final json = jsonDecode(body);
    final promotions = json['data'].map((item) => Promotion.fromJson(item)).toList();
    return promotions;
  }
}