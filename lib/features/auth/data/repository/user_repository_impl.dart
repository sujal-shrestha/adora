import 'package:adora_mobile_app/features/auth/domain/entity/user_entity.dart';
import 'package:adora_mobile_app/features/auth/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<void> registerUser(UserEntity user) {
    // your logic here
    throw UnimplementedError();
  }

  @override
  Future<UserEntity?> loginUser(String email, String password) {
    // your logic here
    throw UnimplementedError();
  }
}
