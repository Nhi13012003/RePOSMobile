class Comment {
  String? id;
  String commentText;
  DateTime commentTime;
  String dishID;
  String clientID;
  DateTime? createAt;
  DateTime? updateAt;
  List<String>? images; // Thêm trường để lưu trữ danh sách đường dẫn ảnh

  // Constructor có tham số images
  Comment({
    this.id,
    required this.commentText,
    required this.commentTime,
    required this.dishID,
    required this.clientID,
    this.createAt,
    this.updateAt,
    this.images, // Thêm tham số images
  });

  // Tạo Comment từ JSON
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      dishID: json['dishID'],
      clientID: json['clientID'],
      createAt: json['createAt'] != null ? DateTime.parse(json['createAt']) : null,
      updateAt: json['updateAt'] != null ? DateTime.parse(json['updateAt']) : null,
      commentText: json['commentText'],
      commentTime: DateTime.parse(json['commentTime']),
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : [], // Xử lý trường images
    );
  }

  // Chuyển đối tượng Comment thành JSON
  Map<String, dynamic> toJson() {
    return {
      'commentText': commentText,
      'commentTime': commentTime.toUtc().toIso8601String(),
      'dishID': dishID,
      'clientID': clientID,
      'images': images ?? [], // Nếu images null, gán giá trị mặc định là danh sách rỗng
    };
  }
}
