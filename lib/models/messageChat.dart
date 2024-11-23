class MessageChat {
  String? id;
  String text;
  String senderId;
  bool whoSend; //true: client, false: employee
  String roomId;
  DateTime? createdAt;

  MessageChat({
    this.id,
    required this.text,
    required this.senderId,
    required this.whoSend,
    required this.roomId,
    this.createdAt
});

  factory MessageChat.fromJson(Map<String, dynamic> json)
  {
    return MessageChat(
        id: json['id'],
        text: json['text'],
        senderId: json['senderId'],
        whoSend: json['senderType'],
        roomId: json['roomId'],
        createdAt: DateTime.parse(json['createdAt']),
    );
  }
  factory MessageChat.fromJsonSocket(Map<String, dynamic> json)
  {
    return MessageChat(
      id: json['id'],
      text: json['text'],
      senderId: json['senderId'],
      whoSend: json['senderType'],
      roomId: json['roomId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'senderId': senderId,
      'senderType': whoSend, // Lưu ý: key là 'sendType'
      'roomId': roomId,
    };
  }
}