import 'package:adora_mobile_app/features/auth/presentation/view/login_view.dart';
import 'package:adora_mobile_app/features/auth/presentation/view_model/login_view_model.dart';
import 'package:adora_mobile_app/features/auth/domain/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
  });

  testWidgets('renders login UI and taps login button', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<LoginViewModel>(
          create: (_) => LoginViewModel(mockUserRepository),
          child: const LoginView(),
        ),
      ),
    );

    // Check if key UI elements are rendered
    expect(find.text('Log In'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2)); // Email & Password fields

    // Enter credentials
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');

    // Tap the login button
    await tester.tap(find.text('Log In'));
    await tester.pump(); // trigger rebuild

    // Ensure event fired (not verifying BLoC logic here)
    expect(find.text('Log In'), findsOneWidget); // still on screen
  });
}
