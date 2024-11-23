import 'package:client_restaurant/auth/authService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:client_restaurant/screens/signupScreen.dart';

import '../main.dart'; // Giả sử bạn đã có trang đăng ký

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/logo/logo1.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 60, left: 22),
            child: Text(
              'Đăng nhập',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 200),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
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
                            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1),
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
                        obscureText: _obscureText,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
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
                            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập mật khẩu';
                          }
                          return null;
                        },
                      ),
                      Gap(20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Quên mật khẩu?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
                        ),
                      ),
                      Gap(70),
                      // Login button
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Lấy giá trị từ các controller
                            String username = _usernameController.text;
                            String password = _passwordController.text;

                            // Gọi phương thức login từ AuthService
                            final  authService = Get.put(AuthController());
                            authService.login(username, password).then((_) {
                              // Nếu đăng nhập thành công, chuyển hướng đến trang chủ
                              if (authService.isAuthenticated) {
                                Get.to(() => MyHomePage());
                              }
                              else Get.snackbar('error', 'loi dang nhap');
                            });
                          }
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: 50,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.lightBlueAccent],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.4),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'ĐĂNG NHẬP',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Gap(20),
                      // Register link
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Bạn chưa có tài khoản? ',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: 'Đăng ký',
                              style: const TextStyle(color: Colors.blue, fontSize: 17),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(() => SignupScreen());
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
