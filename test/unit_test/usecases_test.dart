// test/unit_test/usecases_test.dart

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ---  use-cases & models ---
import 'package:adora_mobile_app/features/ads/domain/usecases/generate_ad_usecase.dart';
import 'package:adora_mobile_app/features/ads/domain/model/ad_result.dart';
import 'package:adora_mobile_app/features/ads/domain/repository/ads_repository.dart';

import 'package:adora_mobile_app/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:adora_mobile_app/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:adora_mobile_app/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:adora_mobile_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:adora_mobile_app/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:adora_mobile_app/features/auth/domain/usecases/upload_profile_image_usecase.dart';

import 'package:adora_mobile_app/features/auth/domain/repository/user_repository.dart';
import 'package:adora_mobile_app/features/auth/domain/entity/user_entity.dart';

// --- mock & fake classes ---
class MockAdsRepository extends Mock implements AdsRepository {}
class MockUserRepository extends Mock implements UserRepository {}

class FakeFile extends Fake implements File {}
class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  setUpAll(() {
    // Register fallback values for any<File>() and any<UserEntity>()
    registerFallbackValue(FakeFile());
    registerFallbackValue(FakeUserEntity());
  });

  group('GenerateAdUseCase', () {
    final mockRepo = MockAdsRepository();
    final useCase = GenerateAdUseCase(mockRepo);
    final adResult = AdResult('http://img.png', 7);

    test('✅ returns AdResult when repo succeeds', () async {
      when(() => mockRepo.generateAd('prompt'))
        .thenAnswer((_) async => adResult);

      final result = await useCase.call('prompt');
      expect(result, adResult);
      verify(() => mockRepo.generateAd('prompt')).called(1);
    });

    test('🚨 rethrows when repo throws', () {
      when(() => mockRepo.generateAd(any()))
        .thenThrow(Exception('oops'));

      expect(() => useCase.call('anything'), throwsException);
      verify(() => mockRepo.generateAd('anything')).called(1);
    });
  });

  group('GetProfileUseCase', () {
    final mockRepo = MockUserRepository();
    final useCase = GetProfileUseCase(mockRepo);
    final user = UserEntity(
      id: '1',
      name: 'Test',
      email: 't@t.com',
      password: '',
      token: 'tok',
      profilePic: 'pic',
      credits: 42,
    );

    test('✅ returns UserEntity when repo succeeds', () async {
      when(() => mockRepo.getProfile())
        .thenAnswer((_) async => user);

      final result = await useCase.call();
      expect(result, user);
      verify(() => mockRepo.getProfile()).called(1);
    });

    test('🚨 rethrows when repo throws', () {
      when(() => mockRepo.getProfile())
        .thenThrow(Exception('fail'));

      expect(() => useCase.call(), throwsException);
      verify(() => mockRepo.getProfile()).called(1);
    });
  });

  group('UpdateProfileUseCase', () {
    final mockRepo = MockUserRepository();
    final useCase = UpdateProfileUseCase(mockRepo);
    final updated = UserEntity(
      id: '1', name: 'A', email: 'a@a.com',
      password: '', token: 't', profilePic: '', credits: 0,
    );

    test('✅ returns updated user when repo succeeds', () async {
      when(() => mockRepo.updateMyProfile(updated))
        .thenAnswer((_) async => updated);

      final result = await useCase.call(updated);
      expect(result, updated);
      verify(() => mockRepo.updateMyProfile(updated)).called(1);
    });

    test('🚨 rethrows when repo throws', () {
      when(() => mockRepo.updateMyProfile(any()))
        .thenThrow(Exception('uh oh'));

      expect(() => useCase.call(updated), throwsException);
      verify(() => mockRepo.updateMyProfile(updated)).called(1);
    });
  });

  group('ChangePasswordUseCase', () {
    final mockRepo = MockUserRepository();
    final useCase = ChangePasswordUseCase(mockRepo);

    test('✅ completes when repo succeeds', () async {
      when(() => mockRepo.changePassword('old','new'))
        .thenAnswer((_) async {});

      await useCase.call('old','new');
      verify(() => mockRepo.changePassword('old','new')).called(1);
    });

    test('🚨 rethrows when repo throws', () {
      when(() => mockRepo.changePassword(any(),any()))
        .thenThrow(Exception('nope'));

      expect(() => useCase.call('o','n'), throwsException);
      verify(() => mockRepo.changePassword('o','n')).called(1);
    });
  });

  group('LogoutUseCase', () {
    final mockRepo = MockUserRepository();
    final useCase = LogoutUseCase(mockRepo);

    test('✅ completes when repo succeeds', () async {
      when(() => mockRepo.logoutUser()).thenAnswer((_) async {});
      await useCase.call();
      verify(() => mockRepo.logoutUser()).called(1);
    });

    test('🚨 rethrows when repo throws', () {
      when(() => mockRepo.logoutUser()).thenThrow(Exception('err'));
      expect(() => useCase.call(), throwsException);
      verify(() => mockRepo.logoutUser()).called(1);
    });
  });

  group('DeleteAccountUseCase', () {
    final mockRepo = MockUserRepository();
    final useCase = DeleteAccountUseCase(mockRepo);

    test('✅ completes when repo succeeds', () async {
      when(() => mockRepo.deleteAccount()).thenAnswer((_) async {});
      await useCase.call();
      verify(() => mockRepo.deleteAccount()).called(1);
    });

    test('🚨 rethrows when repo throws', () {
      when(() => mockRepo.deleteAccount()).thenThrow(Exception('err'));
      expect(() => useCase.call(), throwsException);
      verify(() => mockRepo.deleteAccount()).called(1);
    });
  });

  group('UploadProfileImageUseCase', () {
    final mockRepo = MockUserRepository();
    final useCase = UploadProfileImageUseCase(mockRepo);
    final file = File('some/path.png');

    test('✅ completes when repo succeeds', () async {
      when(() => mockRepo.uploadProfileImage(file))
        .thenAnswer((_) async => Future.value());
      await useCase.call(file);
      verify(() => mockRepo.uploadProfileImage(file)).called(1);
    });

    test('🚨 rethrows when repo throws', () {
      when(() => mockRepo.uploadProfileImage(any()))
        .thenThrow(Exception('err'));
      expect(() => useCase.call(file), throwsException);
      verify(() => mockRepo.uploadProfileImage(file)).called(1);
    });
  });
}
