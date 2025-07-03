import 'package:get_it/get_it.dart';

// Data sources
import '../../features/auth/data/data_source/user_local_datasource.dart';

// Repositories
import '../../features/auth/domain/repository/user_repository.dart';
import '../../features/auth/data/repository/user_local_repository_impl.dart';

// ViewModels (Bloc)
import '../../features/auth/presentation/view_model/login_view_model.dart';
import '../../features/auth/presentation/view_model/signup_view_model.dart';
import '../../features/splash/presentation/view_model/splash_view_model.dart';

final sl = GetIt.instance;

void setupLocator() {
  // Data source (if you still use local for anything — e.g., caching)
  sl.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSourceImpl());

  // Repository (API-based now)
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());

  // Splash ViewModel
  sl.registerFactory(() => SplashViewModel());

  // Auth BLoCs (Login/Signup)
  sl.registerFactory(() => LoginViewModel(sl<UserRepository>()));
  sl.registerFactory(() => SignupViewModel(sl<UserRepository>()));
}
