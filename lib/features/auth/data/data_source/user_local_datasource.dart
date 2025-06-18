import 'package:hive/hive.dart';

import '../../../../app/constant/hive_table_constant.dart';
import '../model/user_model.dart';


abstract class UserLocalDataSource {
  Future<void> addUser(UserModel user);
  UserModel? getUser(String email);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  @override
  Future<void> addUser(UserModel user) async {
    final box = await Hive.openBox<UserModel>(HiveTableConstant.studentBox);
    await box.put(user.email, user);
  }

  @override
  UserModel? getUser(String email) {
    final box = Hive.box<UserModel>(HiveTableConstant.studentBox);
    return box.get(email);
  }
}
