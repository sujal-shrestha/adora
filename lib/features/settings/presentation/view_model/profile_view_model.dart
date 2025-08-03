import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:adora_mobile_app/features/auth/domain/entity/user_entity.dart';
import 'package:adora_mobile_app/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:adora_mobile_app/features/auth/domain/usecases/upload_profile_image_usecase.dart';
import 'package:adora_mobile_app/features/auth/domain/usecases/update_profile_usecase.dart';

part 'profile_state.dart';
part 'profile_event.dart';

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UploadProfileImageUseCase uploadProfileImageUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileViewModel({
    required this.getProfileUseCase,
    required this.uploadProfileImageUseCase,
    required this.updateProfileUseCase,
  }) : super(ProfileInitial()) {
    on<FetchUserProfile>(_onFetchUserProfile);
    on<PickProfileImage>(_onPickProfileImage);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onFetchUserProfile(
      FetchUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final user = await getProfileUseCase();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onPickProfileImage(
      PickProfileImage event, Emitter<ProfileState> emit) async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: event.source, imageQuality: 75);

    if (picked != null) {
      try {
        emit(ProfileLoading());
        await uploadProfileImageUseCase(File(picked.path));
        final updatedUser = await getProfileUseCase();
        emit(ProfileLoaded(updatedUser));
      } catch (e) {
        emit(ProfileError('Failed to upload image: $e'));
      }
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final currentUser = await getProfileUseCase();
      final updatedUser = UserEntity(
        id: currentUser.id,
        name: event.name,
        email: event.email,
        password: '',
        token: currentUser.token,
        profilePic: currentUser.profilePic,
      );
      final newUser = await updateProfileUseCase(updatedUser);
      emit(ProfileLoaded(newUser));
    } catch (e) {
      emit(ProfileError('Failed to update profile: $e'));
    }
  }
}
