// test/widget_test/create_ads_view_test.dart

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adora_mobile_app/features/ads/presentation/view/create_ads_view.dart';
import 'package:adora_mobile_app/features/auth/domain/entity/user_entity.dart';
import 'package:adora_mobile_app/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:adora_mobile_app/features/ads/domain/usecases/generate_ad_usecase.dart';
import 'package:adora_mobile_app/features/ads/domain/model/ad_result.dart';

void main() {
  final sl = GetIt.instance;
  late MockGetProfileUseCase mockGetProfile;
  late MockGenerateAdUseCase mockGenerateAd;

  setUp(() {
    // Reset & re-register
    sl.reset();
    mockGetProfile = MockGetProfileUseCase();
    mockGenerateAd = MockGenerateAdUseCase();

    sl.registerLazySingleton<GetProfileUseCase>(() => mockGetProfile);
    sl.registerLazySingleton<GenerateAdUseCase>(() => mockGenerateAd);
  });

  Future<void> _pumpCreateAds(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: CreateAdsView()),
    );
  }

  testWidgets('1) shows spinner while loading credits', (tester) async {
    // Hold the credits future open
    final completer = Completer<UserEntity>();
    when(() => mockGetProfile()).thenAnswer((_) => completer.future);

    await _pumpCreateAds(tester);
    await tester.pump(); // start initState

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Now complete
    completer.complete(const UserEntity(
      id: '1',
      name: 'x',
      email: 'x',
      password: '',
      token: '',
      profilePic: '',
      credits: 5,
    ));
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('2) displays loaded credits and Buy button', (tester) async {
    when(() => mockGetProfile()).thenAnswer((_) async {
      return const UserEntity(
        id: '1',
        name: 'x',
        email: 'x',
        password: '',
        token: '',
        profilePic: '',
        credits: 7,
      );
    });

    await _pumpCreateAds(tester);
    await tester.pumpAndSettle();

    expect(find.text('Credits: 7'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Buy'), findsOneWidget);
  });

  testWidgets('3) tapping Buy shows placeholder SnackBar', (tester) async {
    when(() => mockGetProfile()).thenAnswer((_) async {
      return const UserEntity(
        id: '1',
        name: 'x',
        email: 'x',
        password: '',
        token: '',
        profilePic: '',
        credits: 7,
      );
    });

    await _pumpCreateAds(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Buy'));
    await tester.pump(); // show SnackBar

    expect(find.text('Buy credits flow not yet implemented'), findsOneWidget);
  });

  testWidgets('4) not enough credits displays SnackBar', (tester) async {
    when(() => mockGetProfile()).thenAnswer((_) async {
      return const UserEntity(
        id: '1',
        name: 'x',
        email: 'x',
        password: '',
        token: '',
        profilePic: '',
        credits: 3,
      );
    });

    await _pumpCreateAds(tester);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'hello');
    await tester.tap(find.text('Generate (5 credits)'));
    await tester.pump();

    expect(find.text('Not enough credits'), findsOneWidget);
  });
}

/// Mocks for our two use‐cases
class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}
class MockGenerateAdUseCase extends Mock implements GenerateAdUseCase {}
