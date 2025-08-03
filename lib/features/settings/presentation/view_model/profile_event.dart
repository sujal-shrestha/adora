part of 'profile_view_model.dart';

abstract class ProfileEvent {}

class FetchUserProfile extends ProfileEvent {}

class PickProfileImage extends ProfileEvent {
  final ImageSource source;

  PickProfileImage(this.source);
}

class UpdateProfile extends ProfileEvent {
  final String name;
  final String email;

  UpdateProfile({required this.name, required this.email});
}
