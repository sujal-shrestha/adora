// lib/features/ads/domain/repository/ads_repository.dart

import '../model/ad_result.dart';

abstract class AdsRepository {
  Future<AdResult> generateAd(String prompt);
}
