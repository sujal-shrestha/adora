// lib/features/auth/data/datasource/profile_remote_data_source.dart

import 'dart:convert';

import 'package:adora_mobile_app/features/auth/data/data_source/user_local_datasource.dart';
import 'package:http/http.dart' as http;
import 'package:adora_mobile_app/core/network/api_config.dart';
import 'package:adora_mobile_app/app/service_locator.dart';
import 'package:adora_mobile_app/features/auth/data/model/user_model.dart';

class ProfileRemoteDataSource {
  final http.Client _client;

  ProfileRemoteDataSource([http.Client? client])
      : _client = client ?? http.Client();

  Future<String?> _getToken() => sl<UserLocalDataSource>().getToken();

  /// Fetches the current user’s profile from `/auth/me`
  Future<UserModel> getProfile() async {
    final token = await _getToken();
    if (token == null) throw Exception('Unauthorized');

    final url = '${await ApiConfig.baseUrl}/auth/me';
    final uri = Uri.parse(url);

    final response = await _client.get(
      uri,
      headers: { 'Authorization': 'Bearer $token' },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch profile (status ${response.statusCode})',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return UserModel.fromJson(json);
  }

  /// Updates the current user’s name & email via PUT `/auth/me`
  Future<UserModel> updateProfile(String name, String email) async {
    final token = await _getToken();
    if (token == null) throw Exception('Unauthorized');

    final url = '${await ApiConfig.baseUrl}/auth/me';
    final uri = Uri.parse(url);

    final response = await _client.put(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type':  'application/json',
      },
      body: jsonEncode({
        'name':  name,
        'email': email,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to update profile (status ${response.statusCode})',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return UserModel.fromJson(json);
  }
}
