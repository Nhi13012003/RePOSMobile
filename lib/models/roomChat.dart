class RoomChat {
  String id;
  String roomKey;
  String clientId;
  String employeeId;

  RoomChat({
    required this.id,
    required this.roomKey,
    required this.clientId,
    required this.employeeId
});

  factory RoomChat.fromJson(Map<String, dynamic> json)
  {
    return RoomChat(
        id: json['id'],
        roomKey: json['roomKey'],
        clientId: json['clientId'],
        employeeId: json['employeeId']
    );
  }

}