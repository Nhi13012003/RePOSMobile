import 'package:client_restaurant/screens/enterOtpScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../apis/clientAPI.dart';

class SendOtpScreen extends StatefulWidget {
  const SendOtpScreen({Key? key}) : super(key: key);
  @override
  State<SendOtpScreen> createState() => SendOtpScreenState();
}

class SendOtpScreenState extends State<SendOtpScreen> {
  TextEditingController email = TextEditingController();
  String? errorText; // Biến chứa thông báo lỗi
  String id = Get.arguments;
  // Phương thức kiểm tra email có hợp lệ không
  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _validateEmail() async{
    if (_isEmailValid(email.text)) {
      setState(() {
        errorText = null;
      });
      await ClientAPI().updateClientEmail(id, email.text);
      Get.to(() => OtpScreen());
    }
    else
      setState(() {
        errorText = "Email không hợp lệ! Vui lòng thử lại.";
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                "https://img.freepik.com/free-vector/emails-concept-illustration_114360-1355.jpg?w=1380&t=st=1673699432~exp=1673700032~hmac=d65454eb5c72e8310209bf8ae770f849ea388f318dc6b9b1300b24b03e8886ca",
                height: 350,
              ),
            ),
            const SizedBox(
              height: 60,
              child: Text(
                "Nhập Email vào để nhận mã xác nhận",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Card(
              child: Column(
                children: [
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.mail),
                      suffixIcon: IconButton(
                        onPressed: _validateEmail,
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.teal,
                        ),
                      ),
                      hintText: "Địa chỉ email",
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      errorText: errorText, // Hiển thị thông báo lỗi nếu có
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
