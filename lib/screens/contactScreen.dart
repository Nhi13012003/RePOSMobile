import 'package:client_restaurant/apis/messageChatAPI.dart';
import 'package:client_restaurant/apis/roomChatAPI.dart';
import 'package:client_restaurant/controllers/MessageController.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../models/messageChat.dart';
import '../models/roomChat.dart'; // Thư viện để định dạng thời gian

class ContactScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ContactScreenState();
  }
}

class ContactScreenState extends State<ContactScreen> {
  final TextEditingController _controller = TextEditingController(); // Controller for text input
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final MessageController messageController = Get.put(MessageController());
  final Map<String, String> _autoReplies = {
    'xin chào': 'Chào bạn! Tôi có thể giúp gì cho bạn?',
    'giờ làm việc': 'Chúng tôi làm việc từ 8h sáng đến 5h chiều, từ thứ Hai đến thứ Sáu.',
    'địa chỉ': 'Địa chỉ của chúng tôi là: 123 Đường ABC, Quận XYZ, Thành phố TP.',
    // ... thêm các câu hỏi và câu trả lời khác ...
  };

  late Socket _socket;

  @override
  void initState() {
    super.initState();
  }

  String _formatTimestamp(DateTime timestamp) {
    // Hàm định dạng thời gian theo dạng giờ:phút AM/PM
    return DateFormat('h:mm a').format(timestamp);
  }

  // Send message to the server via socket
  void _handleSendMessage() async {
    final messageText = _controller.text;
    if (messageText.isNotEmpty) {
      final rooms = await RoomChatAPI().fetchRooms();
      if (rooms != null && rooms.isNotEmpty) {
        final roomId = rooms[0].id;
        final message = MessageChat(
          text: messageText,
          senderId: 'user_id',
          whoSend: true,
          roomId: roomId,
          createdAt: DateTime.now(),
        );
        // Send message via the API and socket
        MessagecChatAPI().createMessage(roomId, message);
        _socket.emit('message', message); // Send the message
        _controller.clear(); // Clear the input field
      }
    }
  }

  @override
  void dispose() {
    messageController.onClose(); // Properly disconnect the socket
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Màu nền nhạt cho trang
      body: Column(
        children: [
          Gap(20),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            color: Colors.blueAccent, // Đặt màu nền cho phần tiêu đề
            child: Text(
              'Hỗ trợ người dùng',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ), // Tiêu đề trên cùng
          Obx(
                () => Expanded(
              child: messageController.messages.isEmpty
                  ? Center(
                child: Text(
                  'Xin chào',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: messageController.messages.length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: messageController.messages[index].whoSend
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: messageController.messages[index].whoSend
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: messageController.messages[index].whoSend
                                ? Colors.blue[100]
                                : Colors.green[100],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: messageController.messages[index].whoSend
                                  ? Radius.circular(12)
                                  : Radius.circular(0),
                              bottomRight: messageController.messages[index].whoSend
                                  ? Radius.circular(0)
                                  : Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            messageController.messages[index].text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            _formatTimestamp(
                                messageController.messages[index].createdAt ??
                                    DateTime.now()),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn của bạn...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _handleSendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
