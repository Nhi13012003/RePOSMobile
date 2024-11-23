import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/messageChat.dart';

class MessagecChatAPI {
  // Sửa phương thức này để trả về List thay vì stream
  Future<List<MessageChat>> fetchMessages(String roomId) async {
    try {
      final url = 'http://localhost:3000/api/roomChat/messages/$roomId';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final body = response.body;
        final json = jsonDecode(body);
        final messages = json as List<dynamic>;
        return messages.map((item) => MessageChat.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load messages');
      }
    } on Exception catch (e) {
      print('Error with fetch messages: $e');
      return [];
    }
  }

  // Cập nhật phương thức này để tạo message
  Future<void> createMessage(String roomId, MessageChat message) async {
    final url = 'http://localhost:3000/api/messageChat/';
    final body = message.toJson();
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      print('Message created successfully');
    } else {
      throw Exception('Failed to create message: ${response.statusCode}');
    }
  }
}
