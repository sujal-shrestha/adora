import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:adora_mobile_app/features/auth/domain/repository/user_repository.dart';
import 'package:adora_mobile_app/features/auth/domain/entity/user_entity.dart';
import 'package:adora_mobile_app/features/auth/presentation/view_model/login_view_model.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockUserRepository mockUserRepository;
  late MockSecureStorage mockSecureStorage;
  late LoginViewModel loginViewModel;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockSecureStorage = MockSecureStorage();

    loginViewModel = LoginViewModel(
      mockUserRepository,
      secureStorage: mockSecureStorage,
    );
  });

  final testUser = UserEntity(
    name: 'Test User',
    email: 'test@example.com',
    password: '',
    token: 'mocked_token',
  );

  blocTest<LoginViewModel, LoginState>(
    'emits [LoginLoading, LoginSuccess] on successful login',
    build: () {
      when(() => mockUserRepository.loginUser(any(), any()))
          .thenAnswer((_) async => testUser);

      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});

      return loginViewModel;
    },
    act: (bloc) => bloc.add(LoginButtonPressed(
      email: 'test@example.com',
      password: 'password123',
    )),
    expect: () => [LoginLoading(), LoginSuccess()],
  );

  blocTest<LoginViewModel, LoginState>(
    'emits [LoginLoading, LoginFailure] when login fails',
    build: () {
      when(() => mockUserRepository.loginUser(any(), any()))
          .thenThrow(Exception('Invalid credentials'));

      return loginViewModel;
    },
    act: (bloc) => bloc.add(LoginButtonPressed(
      email: 'wrong@example.com',
      password: 'wrongpass',
    )),
    expect: () => [
      LoginLoading(),
      LoginFailure('Invalid credentials'),
    ],
  );
}
