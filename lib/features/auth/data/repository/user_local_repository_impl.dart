import '../../domain/entity/user_entity.dart';
import '../../domain/repository/user_repository.dart';
import '../data_source/user_local_datasource.dart';
import '../model/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl(this.localDataSource);

  @override
  Future<void> registerUser(UserEntity user) async {
    final model = UserModel(
      name: user.name,
      email: user.email,
      password: user.password,
    );
    await localDataSource.addUser(model);
  }

  @override
  Future<UserEntity?> loginUser(String email, String password) async {
    final model = await localDataSource.getUser(email);
    if (model == null) return null;

    return model.password == password
        ? UserEntity(
            name: model.name,
            email: model.email,
            password: model.password,
          )
        : null;
  }
}
