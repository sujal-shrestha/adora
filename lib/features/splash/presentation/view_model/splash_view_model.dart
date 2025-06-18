import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/view/login_view.dart';
import '../../../auth/presentation/view_model/login_view_model.dart';

class SplashViewModel {
  void startTimer(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => LoginViewModel(),
            child: const LoginView(),
          ),
        ),
      );
    });
  }
}
