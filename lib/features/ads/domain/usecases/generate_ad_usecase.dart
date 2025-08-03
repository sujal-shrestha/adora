// lib/features/ads/domain/usecases/generate_ad_usecase.dart

import '../../domain/model/ad_result.dart';
import '../repository/ads_repository.dart';

class GenerateAdUseCase {
  final AdsRepository repository;

  GenerateAdUseCase(this.repository);

  Future<AdResult> call(String prompt) {
    return repository.generateAd(prompt);
  }
}
