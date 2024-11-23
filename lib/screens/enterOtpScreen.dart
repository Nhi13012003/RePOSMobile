import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../apis/clientAPI.dart';

class Otp extends StatelessWidget {
  const Otp({
    Key? key,
    required this.otpController,
  }) : super(key: key);

  final TextEditingController otpController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextFormField(
        controller: otpController,
        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: const InputDecoration(
          hintText: ('0'),
        ),
      ),
    );
  }
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();
  TextEditingController otp5Controller = TextEditingController();
  TextEditingController otp6Controller = TextEditingController();

  // Giả sử bạn có một phương thức xác minh OTP
  Future<void> verifyOtp() async {
    String otp = otp1Controller.text + otp2Controller.text + otp3Controller.text +
        otp4Controller.text + otp5Controller.text + otp6Controller.text;

    if (otp.length == 6) {
      print(otp);
      bool isOtpValid = await ClientAPI().verifyOtp(otp);
      if (isOtpValid) {
        // Hiển thị Snackbar thành công
        Get.snackbar("Thành công", "Mã OTP xác minh thành công", snackPosition: SnackPosition.TOP);

        // Điều hướng về trang đăng nhập và xóa các màn hình trước đó
        Get.offAllNamed('/login');
      } else {
        // Hiển thị thông báo OTP không hợp lệ
        Get.snackbar("Lỗi", "Mã OTP không hợp lệ", snackPosition: SnackPosition.TOP);
      }
    } else {
      // Thông báo OTP không đủ dài
      Get.snackbar("Lỗi", "Vui lòng nhập đầy đủ mã OTP", snackPosition: SnackPosition.TOP);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.dialpad_rounded, size: 50),
          const SizedBox(height: 40),
          const Text(
            "Nhập mã xác nhận của bạn",
            style: TextStyle(fontSize: 30),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Otp(otpController: otp1Controller),
              Otp(otpController: otp2Controller),
              Otp(otpController: otp3Controller),
              Otp(otpController: otp4Controller),
              Otp(otpController: otp5Controller),
              Otp(otpController: otp6Controller),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            "Mã xác nhận không hợp lệ",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: verifyOtp,
            child: const Text(
              "Xác minh",
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
