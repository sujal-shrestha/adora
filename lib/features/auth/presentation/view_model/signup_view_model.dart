import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

part 'signup_state.dart';

class SignupViewModel extends Cubit<SignupState> {
  SignupViewModel() : super(SignupInitial());

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> signup(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      emit(SignupFailure('Passwords do not match'));
      return;
    }

    final userBox = Hive.box('users');

    // Check if user already exists
    final existingUser = userBox.values.firstWhere(
      (user) => user['email'] == email,
      orElse: () => null,
    );

    if (existingUser != null) {
      emit(SignupFailure('User already exists'));
      return;
    }

    // Save new user
    await userBox.add({
      'name': name,
      'email': email,
      'password': password,
    });

    emit(SignupSuccess());
  }

  void clearControllers() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
