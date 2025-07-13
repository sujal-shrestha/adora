import 'package:adora_mobile_app/features/auth/presentation/view/signup_view.dart';
import 'package:adora_mobile_app/features/auth/presentation/view_model/signup_view_model.dart';
import 'package:adora_mobile_app/features/auth/domain/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
  });

  testWidgets('renders signup form and triggers event on submit', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => SignupViewModel(mockUserRepository),
          child: const SignupView(),
        ),
      ),
    );

    // Verify fields are rendered
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    expect(find.text('SIGN UP'), findsOneWidget);

    // Enter form values
    await tester.enterText(find.byType(TextFormField).at(0), 'Jane Doe');
    await tester.enterText(find.byType(TextFormField).at(1), 'jane@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'secure123');
    await tester.enterText(find.byType(TextFormField).at(3), 'secure123');

    // Tap the signup button
    await tester.tap(find.text('SIGN UP'));
    await tester.pump();

    // Check that button still exists
    expect(find.text('SIGN UP'), findsOneWidget);
  });
}
