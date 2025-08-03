// lib/features/home/presentation/view/home_view.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:adora_mobile_app/services/jerk_service.dart';
import 'package:adora_mobile_app/features/auth/presentation/view/login_view.dart';

import 'package:adora_mobile_app/features/home/presentation/view/dashboard_view.dart';
import 'package:adora_mobile_app/features/ads/presentation/view/create_ads_view.dart';
import 'package:adora_mobile_app/features/spy/presentation/view/spy_tool_view.dart';
import 'package:adora_mobile_app/features/learn_content/presentation/view/learn_content_view.dart';
import 'package:adora_mobile_app/features/settings/presentation/views/settings_view.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/home';

  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  late final StreamSubscription<void> _jerkSub;

  final List<Widget> _pages = const [
    DashboardView(username: "Sujal"),
    CreateAdsView(),
    SpyToolView(),
    LearnContentView(),
    SettingsView(),
  ];

  @override
  void initState() {
    super.initState();
    // Start accelerometer‐based “jerk” monitoring
    JerkService().start();
    _jerkSub = JerkService().onJerk.listen((_) => _showLogoutPrompt());
  }

  @override
  void dispose() {
    _jerkSub.cancel();
    JerkService().stop();
    super.dispose();
  }

  void _showLogoutPrompt() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout?'),
        content: const Text('Do you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx)
                  .pushNamedAndRemoveUntil(LoginView.routeName, (_) => false);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'Create Ads'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Spy Tools'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Learn'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
