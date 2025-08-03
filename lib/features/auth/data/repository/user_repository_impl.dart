// lib/features/auth/data/repository/user_repository_impl.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:adora_mobile_app/core/network/api_config.dart';
import 'package:adora_mobile_app/features/auth/domain/entity/user_entity.dart';
import 'package:adora_mobile_app/features/auth/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final _storage = const FlutterSecureStorage();

  /// Build the full `/api/auth` base at runtime
  Future<String> get _authBase async {
    final apiBase = await ApiConfig.baseUrl;      
    return '$apiBase/auth';                       
  }

  @override
  Future<void> registerUser(UserEntity user) async {
    final url = '${await _authBase}/register';
    final resp = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name'    : user.name,
        'email'   : user.email,
        'password': user.password,
      }),
    );
    if (resp.statusCode != 201) {
      final body = jsonDecode(resp.body);
      throw Exception(body['message'] ?? 'Registration failed');
    }
  }

  @override
  Future<UserEntity?> loginUser(String email, String password) async {
    final url = '${await _authBase}/login';
    final resp = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({ 'email': email, 'password': password }),
    );

    if (resp.statusCode != 200) {
      String msg;
      try {
        final body = jsonDecode(resp.body);
        msg = body['message'] ?? 'Login failed';
      } catch (_) {
        msg = 'Login failed (${resp.statusCode})';
      }
      throw Exception(msg);
    }

    final data     = jsonDecode(resp.body) as Map<String, dynamic>;
    final userJson = data['user'] as Map<String, dynamic>;
    final token    = data['token'] as String;

    await _storage.write(key: 'token', value: token);

    final serverPic = data['profilePic'] as String?;
    final userPic   = userJson['profilePic'] as String?;
    final pic       = serverPic ?? userPic ?? '';

    return UserEntity(
      id         : userJson['id']      ?? '',
      name       : userJson['name']    ?? '',
      email      : userJson['email']   ?? '',
      password   : '',                   // do not store
      token      : token,
      profilePic : pic,
      credits    : (userJson['credits'] is int) ? userJson['credits'] as int : 0,
    );
  }

  @override
  Future<UserEntity> getProfile() async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('Unauthorized');

    final url  = '${await _authBase}/me';
    final resp = await http.get(
      Uri.parse(url),
      headers: { 'Authorization': 'Bearer $token' },
    );

    final body = jsonDecode(resp.body);
    if (resp.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to fetch profile');
    }

    return UserEntity(
      id         : body['id']         ?? '',
      name       : body['name']       ?? '',
      email      : body['email']      ?? '',
      password   : '',
      token      : token,
      profilePic : body['profilePic'] ?? '',
      credits    : (body['credits'] is int) ? body['credits'] as int : 0,
    );
  }

  @override
  Future<UserEntity> updateMyProfile(UserEntity u) async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('Unauthorized');

    final url  = '${await _authBase}/me';
    final resp = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type' : 'application/json',
      },
      body: jsonEncode({
        'name' : u.name,
        'email': u.email,
      }),
    );

    final body = jsonDecode(resp.body);
    if (resp.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to update profile');
    }

    return UserEntity(
      id         : body['id']         ?? '',
      name       : body['name']       ?? '',
      email      : body['email']      ?? '',
      password   : '',
      token      : token,
      profilePic : body['profilePic'] ?? '',
      credits    : (body['credits'] is int) ? body['credits'] as int : 0,
    );
  }

  @override
  Future<void> changePassword(String current, String next) async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('Unauthorized');

    final url  = '${await _authBase}/me/password';
    final resp = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type' : 'application/json',
      },
      body: jsonEncode({
        'currentPassword': current,
        'newPassword'    : next,
      }),
    );

    if (resp.statusCode != 200) {
      final body = jsonDecode(resp.body);
      throw Exception(body['message'] ?? 'Failed to change password');
    }
  }

  @override
  Future<UserEntity> uploadProfileImage(File image) async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('Unauthorized');

    final url = Uri.parse('${await _authBase}/me/image');
    final req = http.MultipartRequest('PUT', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final streamed = await req.send();
    final resp     = await http.Response.fromStream(streamed);
    final body     = jsonDecode(resp.body);

    if (resp.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to upload profile picture');
    }

    return UserEntity(
      id         : body['id']         ?? '',
      name       : body['name']       ?? '',
      email      : body['email']      ?? '',
      password   : '',
      token      : token,
      profilePic : body['profilePic'] ?? '',
      credits    : (body['credits'] is int) ? body['credits'] as int : 0,
    );
  }

  @override
  Future<void> logoutUser() async {
    await _storage.delete(key: 'token');
  }

  @override
  Future<void> deleteAccount() async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('Unauthorized');

    final url  = '${await _authBase}/me';
    final resp = await http.delete(
      Uri.parse(url),
      headers: { 'Authorization': 'Bearer $token' },
    );

    if (resp.statusCode != 200) {
      final body = jsonDecode(resp.body);
      throw Exception(body['message'] ?? 'Failed to delete account');
    }
    await _storage.delete(key: 'token');
  }
}
