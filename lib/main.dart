import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:adora_mobile_app/app/service_locator.dart';
import 'features/splash/presentation/view/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

  await Hive.initFlutter();
  await Hive.openBox('users');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashView(),
    );
  }
}
