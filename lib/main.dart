// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:adora_mobile_app/app/service_locator.dart';
import 'package:adora_mobile_app/app/constant/hive_table_constant.dart';
import 'package:adora_mobile_app/app/theme_data.dart';

import 'package:adora_mobile_app/features/auth/data/model/user_model.dart';
import 'package:adora_mobile_app/features/auth/presentation/view/login_view.dart';
import 'package:adora_mobile_app/features/auth/presentation/view/signup_view.dart';
import 'package:adora_mobile_app/features/home/presentation/view/home_view.dart';
import 'package:adora_mobile_app/features/splash/presentation/view/splash_view.dart';

import 'package:adora_mobile_app/features/auth/presentation/view_model/login_view_model.dart';
import 'package:adora_mobile_app/features/auth/presentation/view_model/signup_view_model.dart';
import 'package:adora_mobile_app/features/splash/presentation/view_model/splash_view_model.dart';

import 'package:adora_mobile_app/widgets/sensor_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1️⃣ Service locator (must await, since it resolves your ApiConfig.baseUrl)
  await setupLocator();

  // 2️⃣ Hive init & adapter registration
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>(HiveTableConstant.userBox);

  // 3️⃣ Run the app under SensorManager so your sensors
  //    start on launch and pause/resume with lifecycle.
  runApp(
    SensorManager(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Splash BLoC for the splash screen
        BlocProvider<SplashViewModel>(
          create: (_) => sl<SplashViewModel>(),
        ),

        // Login BLoC for the login screen
        BlocProvider<LoginViewModel>(
          create: (_) => sl<LoginViewModel>(),
        ),

        // Signup BLoC for the signup screen
        BlocProvider<SignupViewModel>(
          create: (_) => sl<SignupViewModel>(),
        ),
      ],
      child: MaterialApp(
        title: 'Adora',
        debugShowCheckedModeBanner: false,
        theme: getApplicationTheme(),
        initialRoute: SplashView.routeName,
        routes: {
          SplashView.routeName: (_) => const SplashView(),
          LoginView.routeName:  (_) => const LoginView(),
          SignupView.routeName: (_) => const SignupView(),
          HomeView.routeName:   (_) => const HomeView(),
        },
      ),
    );
  }
}
