import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:adora_mobile_app/features/auth/domain/repository/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  LoginViewModel(this.userRepository) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginPressed);
  }

  Future<void> _onLoginPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      final user = await userRepository.loginUser(event.email, event.password);

      if (user != null && user.token != null) {
        await secureStorage.write(key: 'token', value: user.token);
        emit(LoginSuccess());
      } else {
        emit(LoginFailure("Login failed. Invalid user or token."));
      }
    } catch (e) {
      emit(LoginFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
