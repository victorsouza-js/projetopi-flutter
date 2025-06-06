// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String name;
  final String email;
  final String token;

  UserModel({required this.name, required this.email, required this.token});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'name': name, 'email': email, 'token': token};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['user']['name'] as String,
      email: map['user']['email'] as String,
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
