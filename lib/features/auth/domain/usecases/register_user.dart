import 'package:adora_mobile_app/features/auth/domain/entity/user_entity.dart';
import 'package:adora_mobile_app/features/auth/domain/repository/user_repository.dart';

class RegisterUser {
  final UserRepository repository;

  RegisterUser(this.repository);

  Future<void> call(UserEntity user) {
    return repository.registerUser(user);
  }
}
