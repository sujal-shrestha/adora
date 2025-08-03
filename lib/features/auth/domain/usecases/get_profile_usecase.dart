import 'package:adora_mobile_app/features/auth/domain/entity/user_entity.dart';
import 'package:adora_mobile_app/features/auth/domain/repository/user_repository.dart';

class GetProfileUseCase {
  final UserRepository repository;

  GetProfileUseCase(this.repository);

  Future<UserEntity> call() {
    return repository.getProfile();
  }
}
