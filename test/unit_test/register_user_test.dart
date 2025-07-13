import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:adora_mobile_app/features/auth/domain/entity/user_entity.dart';
import 'package:adora_mobile_app/features/auth/domain/repository/user_repository.dart';
import 'package:adora_mobile_app/features/auth/domain/usecases/register_user.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late RegisterUser registerUser;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    registerUser = RegisterUser(mockUserRepository);
  });

  test('should call registerUser on repository with correct user', () async {
    // arrange
    final testUser = UserEntity(
      name: 'Jane Doe',
      email: 'jane@example.com',
      password: 'secure123',
    );

    when(() => mockUserRepository.registerUser(testUser))
        .thenAnswer((_) async => Future.value());

    // act
    await registerUser(testUser);

    // assert
    verify(() => mockUserRepository.registerUser(testUser)).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });
}
