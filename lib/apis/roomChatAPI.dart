import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/roomChat.dart';
class RoomChatAPI {
  Future<List<RoomChat>> fetchRooms() async
  {
    const url = 'http://localhost:3000/api/roomChat/';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body) as List<dynamic>;
    final rooms = json.map((item) => RoomChat.fromJson(item)).toList();
    return rooms;
  }
}