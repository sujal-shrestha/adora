part of 'signup_view_model.dart';

abstract class SignupEvent {}

class SignupButtonPressed extends SignupEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  SignupButtonPressed({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}
