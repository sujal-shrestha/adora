import 'dart:io';
import 'package:adora_mobile_app/features/auth/domain/repository/user_repository.dart';

class UploadProfileImageUseCase {
  final UserRepository repository;

  UploadProfileImageUseCase(this.repository);

  Future<void> call(File image) async {
    await repository.uploadProfileImage(image);
  }
}
