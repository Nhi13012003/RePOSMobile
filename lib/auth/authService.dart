import 'dart:convert';
import 'package:get/get.dart'; // Sử dụng GetX thay vì ChangeNotifier
import 'package:http/http.dart' as http;
import '../SQLite/databaseHelper.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AuthController extends GetxController {
  var _token = Rxn<String>();
  var _ClientId = Rxn<String>();
  var _ClientName = Rxn<String>();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Getter cho token, ClientId, ClientName
  String? get token => _token.value;
  String? get ClientId => _ClientId.value;
  String? get ClientName => _ClientName.value;

  // Kiểm tra xem đã đăng nhập chưa
  bool get isAuthenticated => _token.value != null && !isTokenExpired(_token.value!);

  // Đăng nhập
  Future<void> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/account/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'accountUsername': username,
          'accountPassword': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        final token = data['token'];
        final ClientId = data['user']['Person']['clientId'];
        final ClientName = data['user']['Person']['name'];

        await _databaseHelper.saveAuthData(token, ClientId, ClientName);

        // Cập nhật các giá trị và thông báo đến UI
        _token.value = token;
        _ClientId.value = ClientId;
        _ClientName.value = ClientName;
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      print('Login failed: $e');
      rethrow;
    }
  }

  // Đăng xuất
  Future<void> logout() async {
    _token.value = null;
    _ClientId.value = null;
    _ClientName.value = null;
    await _databaseHelper.deleteAuthData();
  }

  // Kiểm tra xác thực
  Future<void> checkAuth() async {
    final authData = await _databaseHelper.getAuthData();
    if (authData != null && !isTokenExpired(authData['token'])) {
      _token.value = authData['token'];
      _ClientId.value = authData['clientId'];
      _ClientName.value = authData['clientName'];
    } else {
      logout();
    }
  }

  // Kiểm tra xem token có hết hạn không
  bool isTokenExpired(String token) {
    if (token.isEmpty) return true;

    final decodedToken = Jwt.parseJwt(token);
    final expiryDate = DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
    return expiryDate.isBefore(DateTime.now());
  }
}
