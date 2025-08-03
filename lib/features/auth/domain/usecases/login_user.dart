import 'package:adora_mobile_app/features/auth/domain/entity/user_entity.dart';
import 'package:adora_mobile_app/features/auth/domain/repository/user_repository.dart';

class LoginUser {
  final UserRepository repository;

  LoginUser(this.repository);

  Future<UserEntity?> call(String email, String password) {
    return repository.loginUser(email, password);
  }
}
