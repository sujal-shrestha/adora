import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/auth/data/model/user_model.dart';

class HiveService {
  Future<void> init() async {
    // Get application directory for Hive DB storage
    final dir = await getApplicationDocumentsDirectory();
    Hive.init('${dir.path}/adora_db');

    // Open box for user
    await Hive.openBox<UserModel>('userBox');
  }
}
