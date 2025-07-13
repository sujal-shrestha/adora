import 'package:adora_mobile_app/features/auth/domain/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adora_mobile_app/features/auth/domain/entity/user_entity.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupViewModel extends Bloc<SignupEvent, SignupState> {
  final UserRepository userRepository;

  SignupViewModel(this.userRepository) : super(SignupInitial()) {
    on<SignupButtonPressed>(_onSignupPressed);
  }

  Future<void> _onSignupPressed(
    SignupButtonPressed event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoading());

    if (event.password != event.confirmPassword) {
      emit(SignupFailure('Passwords do not match'));
      return;
    }

    try {
      final user = UserEntity(
        name: event.name,
        email: event.email,
        password: event.password, // ✅ include password!
      );

      await userRepository.registerUser(user);
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
