class Promotion {
  String id;
  String promotionName;
  String promotionDescription;
  String? promotionLimit; // Có thể null nếu không có giá trị
  int discount;
  DateTime startDate;
  DateTime endDate;
  bool isDeleted;
  DateTime updateAt;
  DateTime createAt;
  String? promotionType; // Có thể null nếu không có giá trị

  // Constructor
  Promotion({
    required this.id,
    required this.promotionName,
    required this.promotionDescription,
    this.promotionLimit,
    required this.discount,
    required this.startDate,
    required this.endDate,
    required this.isDeleted,
    required this.updateAt,
    required this.createAt,
    this.promotionType,
  });

  // Phương thức chuyển JSON thành object
  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'],
      promotionName: json['promotionName'],
      promotionDescription: json['promotionDescription'],
      promotionLimit: json['promotionLimit'],
      discount: json['discount'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isDeleted: json['isDeleted'],
      updateAt: DateTime.parse(json['updateAt']),
      createAt: DateTime.parse(json['createAt']),
      promotionType: json['promotionType'],
    );
  }

  // Phương thức chuyển object thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'promotionName': promotionName,
      'promotionDescription': promotionDescription,
      'promotionLimit': promotionLimit,
      'discount': discount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isDeleted': isDeleted,
      'updateAt': updateAt.toIso8601String(),
      'createAt': createAt.toIso8601String(),
      'promotionType': promotionType,
    };
  }
}
