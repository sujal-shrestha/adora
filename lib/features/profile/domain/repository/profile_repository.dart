import 'package:adora_mobile_app/features/auth/domain/entity/user_entity.dart';

abstract class ProfileRepository {
  Future<UserEntity> getProfile();
  Future<UserEntity> updateProfile(UserEntity user);
  Future<String> uploadProfilePic(String imagePath);
}
