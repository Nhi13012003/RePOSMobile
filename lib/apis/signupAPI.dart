import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> signUp(String email, String phoneNumber, String password, bool isMale) async {
  final url = 'https://your-backend-api.com/signup';
  final response = await http.post(Uri.parse(url), body: {
    'email': email,
    'phoneNumber': phoneNumber,
    'password': password,
    'isMale': isMale.toString(),
  });

  if (response.statusCode == 200) {
    // Đăng ký thành công
    print('Đăng ký thành công');
  } else {
    // Xử lý lỗi
    print('Đăng ký thất bại');
  }
}
