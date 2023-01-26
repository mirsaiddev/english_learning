import 'package:hive/hive.dart';

class HiveService {
  Box box = Hive.box('system');

  int getLevel() {
    return box.get('level') ?? 1;
  }

  Future<void> setLevel(int level) async {
    await box.put('level', level);
  }
}
