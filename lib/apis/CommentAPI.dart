import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../models/Comment.dart';

class CommentAPI {
  // Hàm upload ảnh lên server và nhận URL trả về
  Future<String?> uploadImage(File image) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('http://localhost:3000/api/upload'));
      var file = await http.MultipartFile.fromPath(
        'image', // Tên field bạn muốn gửi
        image.path,
        contentType: MediaType('image', 'jpeg'), // Loại ảnh (thay đổi nếu cần)
      );

      request.files.add(file);

      // Gửi request lên server
      var response = await request.send();
      if (response.statusCode == 200) {
        // Server trả về URL của ảnh
        final responseData = await response.stream.bytesToString();
        final url = jsonDecode(responseData)['url']; // Giả sử response trả về là JSON chứa URL
        return url;
      } else {
        print('Upload failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
    return null;
  }

  // Lấy danh sách bình luận theo dishId
  Future<List<Comment>> fetchCommentsWithDishId(String dishId) async {
    try {
      final url = 'http://localhost:3000/api/comment/dish/$dishId';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final body = response.body;
      final json = jsonDecode(body) as List<dynamic>;
      final comments = json.map((item) => Comment.fromJson(item)).toList();
      return comments;
    } on Exception catch (e) {
      print(e);
      return [];
    }
  }

  // Tạo bình luận mới
  Future<void> createComment(Comment comment, List<XFile> images) async {
    final url = 'http://localhost:3000/api/comment/';
    final uri = Uri.parse(url);

    // Upload ảnh và lấy URL
    List<String> imageUrls = [];
    for (var image in images) {
      final imageFile = File(image.path);
      final imageUrl = await uploadImage(imageFile);
      if (imageUrl != null) {
        imageUrls.add(imageUrl);
        print(imageUrl);// Lưu URL ảnh vào danh sách
      }
    }

    // Cập nhật đối tượng comment với URL ảnh
    comment.images = imageUrls;

    final body = comment.toJson();
    final response = await http.post(uri, body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'}, // Thêm header Content-Type
    );

    print(response.body);
    if (response.statusCode == 201) {
      print('Comment created successfully');
    } else {
      throw Exception('Failed to create comment: ${response.statusCode}');
    }
  }
}
