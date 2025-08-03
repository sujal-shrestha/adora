// logout_usecase.dart
import 'package:adora_mobile_app/features/auth/domain/repository/user_repository.dart';

class LogoutUseCase {
  final UserRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() async {
    await repository.logoutUser();
  }
}
