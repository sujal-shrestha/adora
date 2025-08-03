// lib/features/auth/domain/usecases/get_profile_usecase.dart

import 'package:adora_mobile_app/features/auth/domain/entity/user_entity.dart';
import 'package:adora_mobile_app/features/auth/domain/repository/user_repository.dart';

/// A “use case” for fetching the currently authenticated user’s profile.
class GetProfileUseCase {
  final UserRepository _repository;

  GetProfileUseCase(this._repository);

  /// Returns the full [UserEntity], including name, email, token,
  /// profilePic URL and remaining credits.
  Future<UserEntity> call() {
    return _repository.getProfile();
  }
}
