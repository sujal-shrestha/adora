import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entity/user_entity.dart';
import '../../domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final baseUrl = 'http://10.0.2.2:5050/api/auth';

  @override
Future<UserEntity?> loginUser(String email, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );

  print('🔐 Login Status Code: ${response.statusCode}');
  print('📦 Login Response Body: ${response.body}');

  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = jsonDecode(response.body);
    return UserEntity(
      name: data['user']['name'],
      email: data['user']['email'],
      password: '', // password is not returned from server
      token: data['token'],
    );
  } else {
    try {
      final error = jsonDecode(response.body)['message'];
      throw Exception(error ?? 'Login failed');
    } catch (e) {
      throw Exception('Login failed: ${response.body}');
    }
  }
}


  @override
  Future<void> registerUser(UserEntity user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': user.name,
        'email': user.email,
        'password': user.password, // ✅ Correct password usage
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final error = jsonDecode(response.body)['message'];
      throw Exception(error ?? 'Registration failed');
    }
  }
}
