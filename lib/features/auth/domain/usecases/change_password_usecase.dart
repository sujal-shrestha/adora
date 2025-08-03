import 'package:adora_mobile_app/features/auth/domain/repository/user_repository.dart';

class ChangePasswordUseCase {
  final UserRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<void> call(String currentPassword, String newPassword) {
    return repository.changePassword(currentPassword, newPassword);
  }
}
