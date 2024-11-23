import 'package:client_restaurant/models/person.dart';

class Client {
  String? id;
  final int point;
  final String email;
  final String phoneNumber;
  final bool gender;
  final Person person;

  Client({
    this.id,
    required this.point,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.person,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      point: json['point'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      person: Person.fromJson(json['person']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'point': point,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'person': person.toJson(),
    };
  }
}