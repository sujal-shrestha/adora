// lib/features/profile/data/repository/profile_repository_impl.dart

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import 'package:adora_mobile_app/core/network/api_config.dart';
import 'package:adora_mobile_app/features/auth/domain/entity/user_entity.dart';
import 'package:adora_mobile_app/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final _storage = const FlutterSecureStorage();

  /// All profile routes live under `/users` on your API.
  static const _usersPath = '/users';

  /// Fetches the logged-in user.
  @override
  Future<UserEntity> getProfile() async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('Unauthorized');

    final base = await ApiConfig.baseUrl; // resolves to e.g. http://10.0.2.2:5000/api
    final uri  = Uri.parse('$base$_usersPath/me');

    final resp = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (resp.statusCode != 200) {
      throw Exception('Failed to load profile (code ${resp.statusCode})');
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    return UserEntity.fromJson(data);
  }

  /// Updates name, email, and profilePic URL.
  @override
  Future<UserEntity> updateProfile(UserEntity user) async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('Unauthorized');

    final base = await ApiConfig.baseUrl;
    final uri  = Uri.parse('$base$_usersPath/me');

    final resp = await http.put(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type':  'application/json',
      },
      body: jsonEncode({
        'name':       user.name,
        'email':      user.email,
        'profilePic': user.profilePic,
      }),
    );

    if (resp.statusCode != 200) {
      throw Exception('Failed to update profile (code ${resp.statusCode})');
    }

    final wrapped = jsonDecode(resp.body) as Map<String, dynamic>;
    // Assuming your API returns { user: { ... } }
    final updated = wrapped['user'] as Map<String, dynamic>? ?? wrapped;
    return UserEntity.fromJson(updated);
  }

  /// Uploads a local image file to `/users/upload-profile-pic`.
  /// Returns the new `profilePic` URL from the server.
  @override
  Future<String> uploadProfilePic(String imagePath) async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('Unauthorized');

    final base = await ApiConfig.baseUrl;
    final uri  = Uri.parse('$base$_usersPath/upload-profile-pic');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          imagePath,
          contentType: MediaType.parse(
            lookupMimeType(imagePath) ?? 'application/octet-stream',
          ),
        ),
      );

    final streamed = await request.send();
    final resp     = await http.Response.fromStream(streamed);

    if (resp.statusCode != 200) {
      throw Exception('Failed to upload profile picture (code ${resp.statusCode})');
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    // Again assume { user: { profilePic: '...' } }
    final userMap = data['user'] as Map<String, dynamic>? ?? data;
    return userMap['profilePic'] as String? ?? '';
  }
}
