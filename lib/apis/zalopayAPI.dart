import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ZaloPayAPI {
  static const String apiUrl = 'http://localhost:3000/payment'; // Đổi thành IP của server

  static Future<ZaloPayOrder?> createOrder(int amount) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'price': amount}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Dữ liệu nhận được: $data');
        return ZaloPayOrder.fromJson(data);
      } else {
        print('Tạo đơn hàng thất bại: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Lỗi khi tạo đơn hàng: $e');
      return null;
    }
  }

  Future<void> openZaloPayApp(String zpTransToken) async {
    // Kiểm tra nếu ứng dụng ZaloPay đã cài đặt
    final String zaloPayScheme = 'zalopay://app?transToken=$zpTransToken';
    final Uri uri = Uri.parse(zaloPayScheme);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Không thể mở ứng dụng ZaloPay, vui lòng kiểm tra lại URL scheme hoặc cài đặt ứng dụng.');
    }
  }
}

class ZaloPayService {
  static const MethodChannel _channel = MethodChannel('com.example.client_restaurant/zalopay');

  Future<int?> payOrder(String zpTransToken) async {
    try {
      final int? result = await _channel.invokeMethod('payOrder', {
        'zpTransToken': zpTransToken,
      });
      return result;
    } on PlatformException catch (e) {
      print("Lỗi khi gọi phương thức thanh toán ZaloPay: ${e.message}");
      return null;
    }
  }
}

class ZaloPayOrder {
  final String? zpTransToken;
  final String? orderUrl;

  ZaloPayOrder({this.zpTransToken, this.orderUrl});

  factory ZaloPayOrder.fromJson(Map<String, dynamic> json) {
    return ZaloPayOrder(
      zpTransToken: json['zp_trans_token'],
      orderUrl: json['order_url'],
    );
  }
}
