import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:adora_mobile_app/features/auth/domain/entity/user_entity.dart';
import 'package:adora_mobile_app/features/auth/domain/repository/user_repository.dart';
import 'package:adora_mobile_app/features/auth/domain/usecases/login_user.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockUserRepository;
  late LoginUser loginUser;

  setUp(() {
    mockUserRepository = MockUserRepository();
    loginUser = LoginUser(mockUserRepository);
  });

  test('should return UserEntity when login is successful', () async {
    const testEmail = 'test@example.com';
    const testPassword = 'secure123';
    const testUser = UserEntity(
      name: 'Test User',
      email: testEmail,
      password: testPassword,
      token: 'abc123',
    );

    when(() => mockUserRepository.loginUser(testEmail, testPassword))
        .thenAnswer((_) async => testUser);

    final result = await loginUser(testEmail, testPassword);

    expect(result, testUser);
    verify(() => mockUserRepository.loginUser(testEmail, testPassword)).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });
}
