// lib/features/auth/data/data_source/user_local_datasource.dart

import 'package:adora_mobile_app/app/constant/hive_table_constant.dart';
import 'package:adora_mobile_app/features/auth/data/model/user_model.dart';
import 'package:hive/hive.dart';

abstract class UserLocalDataSource {
  Future<void> addUser(UserModel user);
  UserModel? getUser(String email);

  /// ← new
  Future<void> cacheToken(String token);
  Future<String?> getToken();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  static const _tokenKey = 'auth_token';

  @override
  Future<void> addUser(UserModel user) async {
    final box = await Hive.openBox<dynamic>(HiveTableConstant.userBox);
    await box.put(user.email, user);
  }

  @override
  UserModel? getUser(String email) {
    final box = Hive.box<dynamic>(HiveTableConstant.userBox);
    return box.get(email) as UserModel?;
  }

  // ← implement these two
  @override
  Future<void> cacheToken(String token) async {
    final box = await Hive.openBox<dynamic>(HiveTableConstant.userBox);
    await box.put(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    final box = await Hive.openBox<dynamic>(HiveTableConstant.userBox);
    return box.get(_tokenKey) as String?;
  }
}
