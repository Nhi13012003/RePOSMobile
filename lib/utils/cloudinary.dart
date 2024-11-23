import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

const String UPLOAD_PRESET = String.fromEnvironment('VITE_UPLOAD_PRESET');
const String CLOUD_NAME = String.fromEnvironment('VITE_CLOUD_NAME');

Future<String> uploadImage(File file) async {
  // Tạo FormData
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('https://api.cloudinary.com/v1_1/$CLOUD_NAME/image/upload'),
  );

  // Thêm file và upload_preset vào request
  request.fields['upload_preset'] = UPLOAD_PRESET;
  request.files.add(await http.MultipartFile.fromPath('file', file.path));

  // Gửi request
  var response = await request.send();

  // Kiểm tra kết quả
  if (response.statusCode != 200) {
    throw Exception('Upload failed');
  }

  // Đọc kết quả từ response
  var responseData = await response.stream.bytesToString();
  var data = jsonDecode(responseData);

  // Trả về URL của ảnh đã tải lên
  return data['secure_url'];
}
