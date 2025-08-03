import 'dart:io';
import 'package:adora_mobile_app/features/auth/domain/entity/user_entity.dart';

abstract class UserRepository {
  Future<void> registerUser(UserEntity user);
  Future<UserEntity?> loginUser(String email, String password);
  Future<UserEntity> getProfile();
  Future<void> uploadProfileImage(File image);
  Future<UserEntity> updateMyProfile(UserEntity updatedUser);
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<void> logoutUser();
  Future<void> deleteAccount();
}
