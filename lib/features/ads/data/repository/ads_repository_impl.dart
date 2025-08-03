// lib/features/ads/data/repository/ads_repository_impl.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/model/ad_result.dart';
import '../../domain/repository/ads_repository.dart';
import '../datasource/ads_remote_data_source.dart';

class AdsRepositoryImpl implements AdsRepository {
  final AdsRemoteDataSource remote;
  final FlutterSecureStorage storage;

  AdsRepositoryImpl(this.remote, this.storage);

  @override
  Future<AdResult> generateAd(String prompt) async {
    // read token from secure storage
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('Unauthorized');

    // forward to remote, which returns both image URL and updated credits
    return await remote.generateAdImage(prompt, token);
  }
}
