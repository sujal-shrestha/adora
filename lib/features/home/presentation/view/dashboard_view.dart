// lib/features/home/presentation/view/dashboard_view.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:adora_mobile_app/features/ads/presentation/view/create_ads_view.dart';
import 'package:adora_mobile_app/features/learn_content/presentation/view/learn_content_view.dart';

class DashboardView extends StatelessWidget {
  final String? username;
  const DashboardView({Key? key, this.username}) : super(key: key);

  // sample last-7-days data
  List<_DayClicks> get _data => const [
        _DayClicks('Mon', 120),
        _DayClicks('Tue', 150),
        _DayClicks('Wed', 100),
        _DayClicks('Thu', 180),
        _DayClicks('Fri', 160),
        _DayClicks('Sat', 200),
        _DayClicks('Sun', 170),
      ];

  List<FlSpot> get _spots => _data
      .asMap()
      .entries
      .map((e) => FlSpot(e.key.toDouble(), e.value.count.toDouble()))
      .toList();

  Widget _bottomTitle(double value, TitleMeta meta) {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final i = value.toInt();
    if (i < 0 || i >= labels.length) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(labels[i], style: const TextStyle(fontSize: 10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.secondary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Header ───
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hi ${username ?? 'there'} 👋',
                    style: theme.textTheme.headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage:
                            AssetImage('assets/images/avatar.png'),
                      ),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Welcome to Adora, your AI-powered workspace.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // ─── Quick Stats Grid ───
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                // drop from 3.0 → 2.5 so cards are taller
                childAspectRatio: 2.5,
                children: const [
                  _StatCard(
                      icon: Icons.campaign_outlined,
                      label: 'Campaigns',
                      value: '12'),
                  _StatCard(
                      icon: Icons.mouse_outlined,
                      label: 'Clicks',
                      value: '980'),
                  _StatCard(
                      icon: Icons.leaderboard,
                      label: 'Leads',
                      value: '56'),
                  _StatCard(
                      icon: Icons.account_balance_wallet,
                      label: 'Credits',
                      value: '24'),
                ],
              ),
              const SizedBox(height: 24),

              // ─── Performance Chart ───
              SizedBox(
                height: 180,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: _bottomTitle,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles:
                                SideTitles(showTitles: true, interval: 50),
                          ),
                          topTitles:
                              AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles:
                              AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                            left: BorderSide(color: Colors.grey.shade300),
                            top: BorderSide.none,
                            right: BorderSide.none,
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: _spots,
                            isCurved: true,
                            color: accent,
                            barWidth: 3,
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ─── Primary Actions ───
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add_box_rounded),
                      label: const Text('Create Ad'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CreateAdsView()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.lightbulb_outline),
                      label: const Text('Find Ideas'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LearnContentView()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatCard(
      {Key? key, required this.icon, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final grey = Colors.grey[600];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 28, color: grey),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(label,
                    style: TextStyle(fontSize: 12, color: grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DayClicks {
  final String day;
  final int count;
  const _DayClicks(this.day, this.count);
}
