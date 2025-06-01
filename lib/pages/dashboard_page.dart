import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const _HomeScreen(),
    const Center(child: Text("Settings Coming Soon")),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    final headlineStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontFamily: 'Inter Bold',
          fontWeight: FontWeight.bold,
        );
    final bodyStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontFamily: 'OpenSans Regular',
          fontSize: 16,
        );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: ListView(
          children: [
            // Logo Row
            Row(
              children: [
                Image.asset('assets/images/logo_mark.png', height: 48),
                const SizedBox(width: 10),
                Image.asset('assets/images/word_mark.png', height: 36),
              ],
            ),
            const SizedBox(height: 32),

            Text("Hi Sujal 👋", style: headlineStyle),
            const SizedBox(height: 6),
            Text("Let’s grow your brand today", style: bodyStyle),
            const SizedBox(height: 24),

            _FeatureButton(
              icon: Icons.campaign,
              label: 'Create Ads',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _FeatureButton(
              icon: Icons.search,
              label: 'Spy on Competitors',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _FeatureButton(
              icon: Icons.trending_up,
              label: 'See What’s Hot',
              onTap: () {},
            ),
            const SizedBox(height: 32),

            Text('Learn', style: headlineStyle),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _SimpleButton(label: 'Blog 1', onTap: () {}),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SimpleButton(label: 'Blog 2', onTap: () {}),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class _FeatureButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final TextStyle? textStyle;

  const _FeatureButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.lightBlue),
      label: Text(label, style: textStyle),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}

class _SimpleButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final TextStyle? textStyle;

  const _SimpleButton({
    required this.label,
    required this.onTap,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(label, style: textStyle),
    );
  }
}
