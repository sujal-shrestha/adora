import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/view/login_view.dart';
import '../../../auth/presentation/view_model/login_view_model.dart';
import '../../../../app/service_locator.dart';

class SplashViewModel {
  void startTimer(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<LoginViewModel>(),
            child: const LoginView(),
          ),
        ),
      );
    });
  }
}
