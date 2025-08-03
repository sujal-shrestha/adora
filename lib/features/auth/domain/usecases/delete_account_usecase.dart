// delete_account_usecase.dart

import 'package:adora_mobile_app/features/auth/domain/repository/user_repository.dart';

class DeleteAccountUseCase {
  final UserRepository repository;

  DeleteAccountUseCase(this.repository);

  Future<void> call() async {
    await repository.deleteAccount();
  }
}
