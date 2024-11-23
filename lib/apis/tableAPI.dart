import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/table.dart';
class TableAPI {
  Future<List<Table>> fetchTables () async {
    const url = 'localhost/api/table/';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body) as List<dynamic>;
    final tables = json.map((item) => Table.fromJson(item)).toList();
    return tables;
  }
}