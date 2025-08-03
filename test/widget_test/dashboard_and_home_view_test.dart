// test/widget_test/dashboard_and_home_view_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';

// adjust these imports to match your project’s paths:
import 'package:adora_mobile_app/features/home/presentation/view/dashboard_view.dart';
import 'package:adora_mobile_app/features/home/presentation/view/home_view.dart';
import 'package:adora_mobile_app/features/settings/presentation/views/settings_view.dart';

void main() {
  group('DashboardView', () {
    testWidgets('renders greeting, stats cards, chart labels and action buttons',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: DashboardView(username: 'Sujal')),
      );
      await tester.pumpAndSettle();

      // greeting
      expect(find.text('Hi Sujal 👋'), findsOneWidget);

      // stats values
      for (final v in ['12', '980', '56', '24']) {
        expect(find.text(v), findsOneWidget);
      }

      // day‐labels
      for (final d in ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']) {
        expect(find.text(d), findsOneWidget);
      }

      // action buttons
      expect(find.text('Create Ad'), findsOneWidget);
      expect(find.text('Find Ideas'), findsOneWidget);
    });

    testWidgets('has a GridView for quick stats', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: DashboardView(username: 'Sujal')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('displays all 4 stat icons', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: DashboardView(username: 'Sujal')),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.campaign_outlined), findsOneWidget);
      expect(find.byIcon(Icons.mouse_outlined), findsOneWidget);
      expect(find.byIcon(Icons.leaderboard), findsOneWidget);
      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
    });

    testWidgets('renders a LineChart', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: DashboardView(username: 'Sujal')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('is wrapped in a SingleChildScrollView', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: DashboardView(username: 'Sujal')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });

  group('HomeView + BottomNavigation', () {
    testWidgets('has a BottomNavigationBar with correct labels', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HomeView()),
      );
      await tester.pumpAndSettle();

      // one bar
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // labels
      for (final label in ['Dashboard', 'Create Ads', 'Spy Tools', 'Learn', 'Settings']) {
        expect(find.text(label), findsOneWidget);
      }
    });
});
}
