part of 'signup_view_model.dart';

abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupFailure extends SignupState {
  final String message;
  SignupFailure(this.message);
}
