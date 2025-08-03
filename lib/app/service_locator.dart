// lib/app/service_locator.dart

import 'package:adora_mobile_app/services/close_service.dart';
import 'package:adora_mobile_app/services/jerk_service.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Data sources
import 'package:adora_mobile_app/features/auth/data/data_source/user_local_datasource.dart';
import 'package:adora_mobile_app/features/settings/presentation/data/data_sources/profile_remote_data_source.dart';
import 'package:adora_mobile_app/features/ads/data/datasource/ads_remote_data_source.dart';
import 'package:adora_mobile_app/features/learn_content/data/datasource/news_remote_data_source.dart';

// Repositories
import 'package:adora_mobile_app/features/auth/data/repository/user_repository_impl.dart';
import 'package:adora_mobile_app/features/ads/data/repository/ads_repository_impl.dart';
import 'package:adora_mobile_app/features/learn_content/data/repository/news_repository_impl.dart';

// Domain interfaces & use cases
import 'package:adora_mobile_app/features/auth/domain/repository/user_repository.dart';
import 'package:adora_mobile_app/features/ads/domain/repository/ads_repository.dart';
import 'package:adora_mobile_app/features/learn_content/domain/repository/news_repository.dart';

import 'package:adora_mobile_app/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:adora_mobile_app/features/auth/domain/usecases/upload_profile_image_usecase.dart';
import 'package:adora_mobile_app/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:adora_mobile_app/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:adora_mobile_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:adora_mobile_app/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:adora_mobile_app/features/ads/domain/usecases/generate_ad_usecase.dart';
import 'package:adora_mobile_app/features/learn_content/domain/usecases/get_news_usecase.dart';

// Presentation (Blocs / ViewModels)
import 'package:adora_mobile_app/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:adora_mobile_app/features/auth/presentation/view_model/login_view_model.dart';
import 'package:adora_mobile_app/features/auth/presentation/view_model/signup_view_model.dart';
import 'package:adora_mobile_app/features/settings/presentation/view_model/change_password_view_model.dart';
import 'package:adora_mobile_app/features/settings/presentation/view_model/logout_view_model.dart';
import 'package:adora_mobile_app/features/settings/presentation/view_model/delete_account_view_model.dart';
import 'package:adora_mobile_app/features/settings/presentation/view_model/profile_view_model.dart';
import 'package:adora_mobile_app/features/ads/presentation/bloc/generate_ad_bloc.dart';
import 'package:adora_mobile_app/features/learn_content/presentation/bloc/learn_content_bloc.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // ─── Core / Utilities ──────────────────────────────────────────
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // ─── Data Sources ──────────────────────────────────────────────
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(),
  );

  sl.registerLazySingleton<AdsRemoteDataSource>(
    () => AdsRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(),
  );

  // ─── Repositories ──────────────────────────────────────────────
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(),
  );

  sl.registerLazySingleton<AdsRepository>(
    () => AdsRepositoryImpl(
      sl<AdsRemoteDataSource>(),
      sl<FlutterSecureStorage>(),
    ),
  );

  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      sl<NewsRemoteDataSource>(),
    ),
  );

  // ─── Use Cases ─────────────────────────────────────────────────
  sl.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(sl<UserRepository>()),
  );
  sl.registerLazySingleton<UploadProfileImageUseCase>(
    () => UploadProfileImageUseCase(sl<UserRepository>()),
  );
  sl.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(sl<UserRepository>()),
  );
  sl.registerLazySingleton<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(sl<UserRepository>()),
  );
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(sl<UserRepository>()),
  );
  sl.registerLazySingleton<DeleteAccountUseCase>(
    () => DeleteAccountUseCase(sl<UserRepository>()),
  );

  sl.registerLazySingleton<GenerateAdUseCase>(
    () => GenerateAdUseCase(sl<AdsRepository>()),
  );
  sl.registerLazySingleton<GetNewsUseCase>(
    () => GetNewsUseCase(sl<NewsRepository>()),
  );

  // ─── Presentation Layer ────────────────────────────────────────
  sl.registerFactory<SplashViewModel>(
    () => SplashViewModel(sl<FlutterSecureStorage>()),
  );
  sl.registerFactory<LoginViewModel>(
    () => LoginViewModel(sl<UserRepository>()),
  );
  sl.registerFactory<SignupViewModel>(
    () => SignupViewModel(sl<UserRepository>()),
  );
  sl.registerFactory<ChangePasswordViewModel>(
    () => ChangePasswordViewModel(
      changePasswordUseCase: sl<ChangePasswordUseCase>(),
    ),
  );
  sl.registerFactory<LogoutViewModel>(
    () => LogoutViewModel(sl<LogoutUseCase>()),
  );
  sl.registerFactory<DeleteAccountViewModel>(
    () => DeleteAccountViewModel(sl<DeleteAccountUseCase>()),
  );
  sl.registerFactory<ProfileViewModel>(
    () => ProfileViewModel(
      getProfileUseCase: sl<GetProfileUseCase>(),
      uploadProfileImageUseCase: sl<UploadProfileImageUseCase>(),
      updateProfileUseCase: sl<UpdateProfileUseCase>(),
    ),
  );
  sl.registerFactory<GenerateAdBloc>(
    () => GenerateAdBloc(sl<GenerateAdUseCase>()),
  );
  sl.registerFactory<LearnContentBloc>(
    () => LearnContentBloc(sl<GetNewsUseCase>()),
  );

  // sensor services as singletons:
  sl.registerLazySingleton<ProximityService>(() => ProximityService());
  sl.registerLazySingleton<JerkService>(() => JerkService());
}
