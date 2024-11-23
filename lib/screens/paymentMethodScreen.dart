import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart'; // Thêm package url_launcher
import '../apis/zalopayAPI.dart';  // Đảm bảo bạn đã import ZaloPay API

class Paymentmethodscreen extends StatefulWidget {
  const Paymentmethodscreen({super.key});

  @override
  State<Paymentmethodscreen> createState() => _PaymentmethodscreenState();
}

class _PaymentmethodscreenState extends State<Paymentmethodscreen> {
  int type = 1; // ZaloPay được chọn mặc định
  String zpTransToken = "";
  bool showResult = false;

  void handleRadio(Object? e) => setState(() {
    type = e as int;
  });

  // Xử lý thanh toán khi nhấn nút xác nhận thanh toán
  void handlePayment() async {
    if (type == 1) {
      int amount = 10000; // Số tiền thanh toán
      var order = await ZaloPayAPI.createOrder(amount);
      if (order != null && order.zpTransToken != null) {
        ZaloPayService zaloPayService = ZaloPayService();
        await zaloPayService.payOrder(order.zpTransToken!);
      } else {
        print("Không thể tạo đơn hàng ZaloPay");
      }
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Không thể mở URL: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phương thức thanh toán'),
        leading: BackButton(),
        backgroundColor: Colors.transparent,
        foregroundColor: CupertinoColors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Gap(40),
                    // Phương thức thanh toán ZaloPay
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 55,
                      decoration: BoxDecoration(
                          border: type == 1
                              ? Border.all(width: 1, color: Colors.blue)
                              : Border.all(width: 0.3, color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.transparent),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Radio(
                                    value: 1,
                                    groupValue: type,
                                    onChanged: handleRadio,
                                    activeColor: Colors.blue,
                                  ),
                                  Text('ZaloPay',
                                    style: type == 1
                                        ? TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue,
                                    )
                                        : TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Image.asset('assets/logo/zalopay.webp',
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Gap(15),
                    // Các phương thức thanh toán khác nếu có
                    Gap(70),
                    // Nút xác nhận thanh toán
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        onPressed: handlePayment, // Khi nhấn xác nhận thanh toán
                        child: Text('Xác nhận thanh toán', style: TextStyle(color: Colors.white)),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: Size(double.infinity, 50), // Đặt chiều cao là 50
                        ),
                      ),
                    )
                  ],
                ),
              ))),
    );
  }
}
