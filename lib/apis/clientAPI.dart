import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/client.dart'; // Đảm bảo bạn import model Client

class ClientAPI {
  final String baseUrl = 'http://localhost:3000/api/client'; // Đường dẫn API

  // Phương thức fetch Client dựa trên personId
  Future<Client?> fetchClientById(String personId) async {
    try {
      final url = '$baseUrl/$personId'; // Xây dựng URL với personId
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return Client.fromJson(json); // Chuyển đổi JSON thành đối tượng Client
      } else {
        print('Failed to fetch client: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> createClient(String accountUsername, String accountPassword, String name, bool gender) async {
    try {
      final url = '$baseUrl'; // Đường dẫn đến API
      final uri = Uri.parse(url);

      // Tạo một Map chứa các tham số gửi lên API
      final clientData = {
        'accountUsername': accountUsername,
        'accountPassword': accountPassword,
        'name': name,
        'gender': gender,
      };

      // Gửi POST request để tạo mới Client
      final response = await http.post(
        uri,
        body: jsonEncode(clientData), // Chuyển đổi Map thành JSON
        headers: {'Content-Type': 'application/json'}, // Đặt header là application/json
      );

      print(response.body);

      if (response.statusCode == 201) {
        // Giả sử API trả về đối tượng client với ID
        final responseJson = jsonDecode(response.body);

        // Trả về ID của client vừa tạo
        return responseJson['id']; // Lấy giá trị 'id' từ phản hồi
      } else {
        print('Failed to create client: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
  // Phương thức cập nhật thông tin Client
  Future<void> updateClient(String clientId, String name, String profilePicture, String point, String email, String phoneNumber) async {
    try {
      final url = '$baseUrl/$clientId'; // Sử dụng clientId thay vì client.id
      final uri = Uri.parse(url);

      // Tạo một Map chứa các tham số cần cập nhật
      final clientData = {
        'name': name,
        'profilePicture': profilePicture,
        'point': point,
        'email': email,
        'phoneNumber': phoneNumber,
      };

      // Gửi PUT request để cập nhật Client
      final response = await http.put(
        uri,
        body: jsonEncode(clientData), // Chuyển đổi Map thành JSON
        headers: {'Content-Type': 'application/json'}, // Đặt header là application/json
      );

      if (response.statusCode == 200) {
        print('Client updated successfully');
      } else {
        print('Failed to update client: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }
  Future<void> updateClientEmail(String clientId, String email) async {
    try {
      final url = '$baseUrl/$clientId'; // Sử dụng clientId thay vì client.id
      final uri = Uri.parse(url);

      // Tạo một Map chứa các tham số cần cập nhật
      final clientData = {
        'email': email,
      };

      // Gửi PUT request để cập nhật Client
      final response = await http.put(
        uri,
        body: jsonEncode(clientData), // Chuyển đổi Map thành JSON
        headers: {'Content-Type': 'application/json'}, // Đặt header là application/json
      );

      if (response.statusCode == 200) {
        print('Client updated successfully');
      } else {
        print('Failed to update client: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }
  Future<bool> verifyOtp(String otp) async {
    try {
      final url = '$baseUrl/verified'; // Đường dẫn xác minh OTP
      final uri = Uri.parse(url);

      // Tạo một Map chứa OTP gửi lên server
      final otpData = {'otp': otp};

      // Gửi POST request xác minh OTP
      final response = await http.post(
        uri,
        body: jsonEncode(otpData), // Chuyển đổi Map thành JSON
        headers: {'Content-Type': 'application/json'}, // Đặt header là application/json
      );

      if (response.statusCode == 200) {
        // Trả về true nếu OTP xác minh thành công
        final responseJson = jsonDecode(response.body);
        return true;
      } else {
        print('Failed to verify OTP: ${response.statusCode}');
        return false; // Trả về false nếu OTP không hợp lệ
      }
    } catch (e) {
      print(e);
      return false; // Trả về false nếu có lỗi trong quá trình gọi API
    }
  }


  // Phương thức đăng nhập
  Future<Client?> loginClient(String username, String password) async {
    try {
      final url = '$baseUrl/login'; // Đường dẫn API cho đăng nhập
      final uri = Uri.parse(url);
      final response = await http.post(
        uri,
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return Client.fromJson(json); // Trả về thông tin client nếu đăng nhập thành công
      } else {
        print('Login failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
