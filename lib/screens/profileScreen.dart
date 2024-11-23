import 'package:client_restaurant/SQLite/databaseHelper.dart';
import 'package:client_restaurant/apis/clientAPI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'QrScannerScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final double coverHeight = 280;
  final double profileHeight = 144;

  // Future để lấy ClientId
  Future<String> getClientIdFromSqlite() async {
    final authData = await databaseHelper.getAuthData();
    print(authData);
    print(authData!['employeeId']);
    return authData!['employeeId'];

  }

  @override
  Widget build(BuildContext context) {
    final top = coverHeight - profileHeight / 2;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: FutureBuilder<String>(
        future: getClientIdFromSqlite(), // Lấy ClientId từ SQLite
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Có lỗi xảy ra'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Không có dữ liệu'));
          } else {
            // Lấy ClientId từ snapshot
            final clientId = snapshot.data;

            return FutureBuilder(
              future: ClientAPI().fetchClientById(clientId!), // Fetch client bằng ClientId
              builder: (context, clientSnapshot) {
                if (clientSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (clientSnapshot.hasError) {
                  return Center(child: Text('Có lỗi xảy ra khi tải thông tin khách hàng'));
                } else if (!clientSnapshot.hasData) {
                  return Center(child: Text('Không có dữ liệu khách hàng'));
                } else {
                  // Giả sử fetchClientById trả về một đối tượng với thông tin khách hàng
                  var clientData = clientSnapshot.data;

                  return Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                            color: Colors.grey,
                            child: Image.network(
                              "https://img.freepik.com/premium-photo/grainy-gradient-background-red-white-blue-colors-with-soft-faded-watercolor-border-texture_927344-24167.jpg",
                              fit: BoxFit.cover,
                            ),
                            width: double.infinity,
                            height: coverHeight,
                          ),
                          Positioned(
                            top: top,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4.0,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: profileHeight / 2,
                                backgroundColor: Colors.grey.shade800,
                                backgroundImage: NetworkImage(
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfMjuLOIBCBsEFsUBn1dpVO5-31bUCQdo5Bw&s"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(70),
                      Center(
                        child: Text(
                          clientData!.person.name, // Giả sử clientData có trường 'name'
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Gap(16),
                      _buildInfoLine('Số điện thoại:', clientData.phoneNumber),
                      _buildInfoLine('Email:', clientData.email),
                      _buildInfoLine('Giới tính:', clientData.gender?"Nam":"Nữ"),
                      _buildInfoLine('Điểm tích lũy:', clientData.point.toString()),
                      Gap(32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Handle Setting button press
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            ),
                            child: Icon(Icons.settings),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Handle Gift button press
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            ),
                            child: Icon(Icons.card_giftcard),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final qrResult = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => QrScannerScreen()),
                              );
                              if (qrResult != null) {
                                print("QR Code: $qrResult"); // Xử lý QR code ở đây
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            ),
                            child: Icon(Icons.qr_code),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Handle Logout button press
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            ),
                            child: Icon(Icons.logout),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
