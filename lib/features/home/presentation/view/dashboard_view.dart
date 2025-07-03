import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  final String? username;

  const DashboardView({super.key, this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi ${username ?? 'there'} 👋',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              const Text('Welcome to Adora, your AI-powered workspace.'),
              const SizedBox(height: 24),

              // Stats Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard('Campaigns', '12'),
                  _buildStatCard('Clicks', '980'),
                  _buildStatCard('Leads', '56'),
                ],
              ),
              const SizedBox(height: 24),

              // Primary Actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Create Ad'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Generate Content'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              const Text('Recent Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.campaign_outlined),
                      title: Text('Created "Summer Promo" campaign'),
                      subtitle: Text('2 hours ago'),
                    ),
                    ListTile(
                      leading: Icon(Icons.edit_note),
                      title: Text('Generated ad copy for Facebook'),
                      subtitle: Text('1 day ago'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
