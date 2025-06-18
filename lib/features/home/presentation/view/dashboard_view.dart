import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  final String? username;

  const DashboardView({super.key, this.username});

  @override
  Widget build(BuildContext context) {
    final headlineStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontFamily: 'Inter Bold',
          fontWeight: FontWeight.bold,
        );

    final bodyStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontFamily: 'OpenSans Regular',
        );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hi ${username ?? 'there'} 👋', style: headlineStyle),
            const SizedBox(height: 10),
            Text('Welcome to Adora', style: bodyStyle),
          ],
        ),
      ),
    );
  }
}
