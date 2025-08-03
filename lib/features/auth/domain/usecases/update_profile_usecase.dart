import 'package:adora_mobile_app/features/auth/domain/entity/user_entity.dart';
import 'package:adora_mobile_app/features/auth/domain/repository/user_repository.dart';

class UpdateProfileUseCase {
  final UserRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<UserEntity> call(UserEntity updatedUser) {
    return repository.updateMyProfile(updatedUser);
  }
}
