// lib/features/ads/data/datasource/ads_remote_data_source.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:adora_mobile_app/core/network/api_config.dart';
import '../../domain/model/ad_result.dart';

/// Contract
abstract class AdsRemoteDataSource {
  /// Sends [prompt] and the user’s [token] to the backend,
  /// and returns both the image URL (e.g. "/uploads/xyz.png")
  /// and the updated credit balance.
  Future<AdResult> generateAdImage(String prompt, String token);
}

class AdsRemoteDataSourceImpl implements AdsRemoteDataSource {
  AdsRemoteDataSourceImpl();

  @override
  Future<AdResult> generateAdImage(String prompt, String token) async {
    // 1️⃣ Build the full base (e.g. http://10.0.2.2:5000/api)
    final apiBase = await ApiConfig.baseUrl;

    // 2️⃣ Append your ads path
    final adsBase = '$apiBase/ads';

    // 3️⃣ Point at the generate endpoint
    final uri = Uri.parse('$adsBase/generate');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type' : 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({ 'prompt': prompt }),
    );

    if (response.statusCode != 200) {
      final err = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(err['message'] ?? 'Failed to generate ad');
    }

    final map = jsonDecode(response.body) as Map<String, dynamic>;
    return AdResult(
      map['image'] as String,
      map['remainingCredits'] as int,
    );
  }
}
