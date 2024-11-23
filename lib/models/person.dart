import 'account.dart';

class Person {
  String? id;
  final String name;
  final String profilePicture;
  final bool isDeleted;
  final DateTime updateAt;
  final DateTime createAt;
  final String? employeeId;
  final String? clientId;
  final List<Account> account;

  Person({
    this.id,
    required this.name,
    required this.profilePicture,
    required this.isDeleted,
    required this.updateAt,
    required this.createAt,
    this.employeeId,
    this.clientId,
    required this.account,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      profilePicture: json['profilePicture'],
      isDeleted: json['isDeleted'],
      updateAt: DateTime.parse(json['updateAt']),
      createAt: DateTime.parse(json['createAt']),
      employeeId: json['employeeId'],
      clientId: json['clientId'],
      account: (json['account'] as List)
          .map((item) => Account.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profilePicture': profilePicture,
      'isDeleted': isDeleted,
      'updateAt': updateAt.toIso8601String(),
      'createAt': createAt.toIso8601String(),
      'employeeId': employeeId,
      'clientId': clientId,
      'account': account.map((item) => item.toJson()).toList(),
    };
  }
}
