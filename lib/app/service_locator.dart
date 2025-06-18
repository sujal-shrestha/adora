import 'package:get_it/get_it.dart';
import '../features/splash/presentation/view_model/splash_view_model.dart';
import '../../features/auth/data/data_source/user_local_datasource.dart';
import '../../features/auth/domain/repository/user_repository.dart';
import '../features/auth/data/repository/user_local_repository_impl.dart';

final sl = GetIt.instance;

void setupLocator() {
  // Data source
  sl.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSourceImpl());

  // Repository
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));

  // ViewModel
  sl.registerFactory(() => SplashViewModel());
}
