// lib/features/splash/presentation/view/splash_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/view/login_view.dart';
import '../../../home/presentation/view/home_view.dart';
import '../view_model/splash_view_model.dart';

class SplashView extends StatefulWidget {
  static const routeName = '/splash';

  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // Kick off the splash check
    context.read<SplashViewModel>().start();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashViewModel, SplashState>(
      listener: (context, state) {
        if (state is SplashAuthenticated) {
          Navigator.pushReplacementNamed(context, HomeView.routeName);
        } else if (state is SplashUnauthenticated) {
          Navigator.pushReplacementNamed(context, LoginView.routeName);
        }
      },
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
