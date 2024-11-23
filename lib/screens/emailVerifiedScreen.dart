import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import 'loginScreen.dart';  // Thêm Get để sử dụng Get.to

class EmailVerificationPage extends StatefulWidget {
  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final TextEditingController _codeController = TextEditingController();
  String _message = '';

  // Hàm kiểm tra mã hợp lệ
  Future<bool> _isValidCode(String code) async {
    final url = 'http://localhost:3000/api/client/verified';
    final body = jsonEncode({"otp": code});  // Tạo đối tượng JSON với trường otp
    final uri = Uri.parse(url);

    final response = await http.post(
      uri,
      body: body,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;  // Nếu thành công, trả về true
    } else {
      return false;  // Nếu thất bại, trả về false
    }
  }

  // Hàm xử lý xác minh mã
  void _verifyCode() async {
    final code = _codeController.text;
    bool isValid = await _isValidCode(code);

    if (isValid) {
      // Hiển thị SnackBar thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Code is valid. Verification complete!'),
          backgroundColor: Colors.green,
        ),
      );

      // Chuyển sang màn hình Login
      Get.to(() => LoginScreen());
    } else {
      // Hiển thị SnackBar thông báo thất bại
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid 6-digit code.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please enter the verification code sent to your email:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Verification Code',
                border: OutlineInputBorder(),
                hintText: 'Enter 6-digit code',
              ),
              maxLength: 6, // Giới hạn số ký tự cho mã
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyCode,
              child: Text('Verify Code'),
            ),
            SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
