// lib/features/learn_content/data/datasource/news_remote_data_source.dart

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:adora_mobile_app/core/network/api_config.dart';

import '../model/article_model.dart';

/// Contract for fetching news articles.
abstract class NewsRemoteDataSource {
  /// Queries your `/api/news` endpoint for [query] and returns a list of articles.
  Future<List<ArticleModel>> fetchNews(String query);
}

/// Implementation that routes through ApiConfig to figure out the right host.
class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  /// You can optionally pass a sub-path (e.g. '/news') here,
  /// but by default we'll assume `/api/news` lives under the same base.
  final String _newsPath;

  NewsRemoteDataSourceImpl({String newsPath = '/news'}) : _newsPath = newsPath;

  @override
  Future<List<ArticleModel>> fetchNews(String query) async {
    // 1️⃣ Resolve the base API URL at runtime (emulator vs device).
    final apiBase = await ApiConfig.baseUrl;      // e.g. "http://10.0.2.2:5000/api"
    final fullUrl = '$apiBase$_newsPath?q=$query';// -> ".../api/news?q=flutter"

    final uri = Uri.parse(fullUrl);
    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw Exception('Failed to fetch news (code ${resp.statusCode})');
    }

    final Map<String, dynamic> decoded = jsonDecode(resp.body);
    final List articlesJson = decoded['articles'] as List? ?? [];

    return articlesJson
        .map((j) => ArticleModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }
}
