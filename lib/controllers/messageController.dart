import 'package:client_restaurant/apis/messageChatAPI.dart';
import 'package:client_restaurant/models/roomChat.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../apis/roomChatAPI.dart';
import '../models/messageChat.dart';

class MessageController extends GetxController {
  // Danh sách các tin nhắn
  RxList<MessageChat> messages = <MessageChat>[].obs;

  // Kết nối với socket server
  late IO.Socket socket;
  @override
  void onInit() {
    super.onInit();
    // Khởi tạo kết nối socket hoặc các công việc khởi tạo khác
    createConnection('Pham van nhi');
  }
  // Khởi tạo kết nối socket
  createConnection(String user) {
    socket = IO.io('http://localhost:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setExtraHeaders({'foo': 'bar'})
            .build()
    );
    socket.connect();

    socket.onConnect((_) {
      socket.emit('OnConnected', user);

      socket.on('allMessages', (data) {
        final allMessages = (data as List<dynamic>)
            .map((message) => MessageChat.fromJson(message))
            .toList();
        messages.assignAll(allMessages);
      });
    });

    socket.on('messageCreated', NewMessage); // Lắng nghe tin nhắn mới từ server

    socket.onDisconnect((_) => print('disconnected'));
  }

  // Xử lý tin nhắn mới
  void NewMessage(dynamic data) {
    print('New message received');
    final memberServer = data as Map<String, dynamic>;
    final mess = MessageChat.fromJson(memberServer);
    messages.add(mess);
    messages.refresh();
  }

  // Hàm fetch tin nhắn
  void fetchMessages() async {
    RoomChat room = await fetchRooms();
    final fetchedMessages = await MessagecChatAPI().fetchMessages(room.id);
    messages.assignAll(fetchedMessages); // Cập nhật danh sách tin nhắn
  }

  // Hàm fetch phòng
  Future<RoomChat> fetchRooms() async {
    final fetchedRooms = await RoomChatAPI().fetchRooms();
    return fetchedRooms[0]; // Giả sử chúng ta lấy phòng đầu tiên
  }

  // Xóa tất cả tin nhắn
  void clearMessages() {
    messages.clear();
  }

  @override
  void onClose() {
    socket.disconnect();  // Ngắt kết nối socket khi đóng controller
    super.onClose();
  }
}
