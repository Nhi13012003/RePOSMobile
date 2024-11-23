import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:client_restaurant/screens/sendOtpScreen.dart';
import 'package:client_restaurant/apis/clientAPI.dart'; // Import ClientAPI
import 'package:client_restaurant/models/client.dart';

import 'loginScreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false; // Toggle for password visibility
  ClientAPI clientAPI = ClientAPI();

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String username = _usernameController.text;
      String password = _passwordController.text;
      bool gender = _selectedGender == 'Nam';
      try {
        String? id = await clientAPI.createClient(
            username, password, name, gender);
        Get.to(() => const SendOtpScreen(), arguments: id);
      } catch (e) {
        Get.snackbar('Lỗi', 'Đăng ký thất bại!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/logo/logo1.jpg', // Đường dẫn đến hình ảnh nền
              fit: BoxFit.cover, // Đảm bảo hình ảnh phủ kín toàn bộ màn hình
            ),
          ),

          // Content on top of the background
          Padding(
            padding: EdgeInsets.only(top: 60, left: 22),
            child: Text(
              'Đăng ký',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white), // Chữ màu trắng
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 200),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1), // Màu nền mờ
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Gap(30),
                      // Name TextField
                      TextFormField(
                        controller: _nameController,
                        style: TextStyle(color: Colors.white), // Màu chữ trắng
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person, color: Colors.white),
                          label: Text(
                            'Họ và tên',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Màu chữ nhãn trắng
                              fontSize: 18,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent, width: 2),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white, width: 1),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập họ và tên';
                          }
                          return null;
                        },
                      ),
                      Gap(20),
                      // Username TextField
                      TextFormField(
                        controller: _usernameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_2, color: Colors.white),
                          label: Text(
                            'Tên đăng nhập',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent, width: 2),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white, width: 1),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập tên đăng nhập';
                          }
                          return null;
                        },
                      ),
                      Gap(20),
                      // Password TextField
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          label: Text(
                            'Mật khẩu',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent, width: 2),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white, width: 1),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập mật khẩu';
                          } else if (value.length < 6) {
                            return 'Mật khẩu phải có ít nhất 6 ký tự';
                          }
                          return null;
                        },
                      ),
                      Gap(20),
                      // Gender Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        hint: Text("Chọn giới tính",
                            style: TextStyle(color: Colors.white)),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person, color: Colors.blue),
                          labelStyle: TextStyle(color: Colors.white),
                          fillColor: Colors.blue.shade100,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        items: ['Nam', 'Nữ']
                            .map((gender) =>
                            DropdownMenuItem<String>(
                              value: gender,
                              child: Text(gender,
                                  style: TextStyle(color: Colors.black)),
                            ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Vui lòng chọn giới tính';
                          }
                          return null;
                        },
                      ),
                      Gap(20),
                      // Phone Number TextField
                      // Sign up button
                      GestureDetector(
                        onTap: _signup,
                        child: Container(
                          height: 45,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Đăng ký',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Gap(25),
                      // Login link
                      RichText(
                        text: TextSpan(
                          text: 'Bạn đã có tài khoản? ',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          children: [
                            TextSpan(
                              text: 'Đăng nhập',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(() => const LoginScreen());
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
