// lib/features/auth/data/model/user_model.dart

import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;

  @HiveField(4)
  final String? profilePic;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.profilePic,
  });

  /// JSON-deserialization factory
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      password: '', // server won’t send you the password back
      profilePic: json['profilePic'] as String?,
    );
  }

  /// JSON-serialization (if you ever need it)
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'profilePic': profilePic,
      };
}
