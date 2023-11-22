import 'package:shared_preferences/shared_preferences.dart';

enum SharedKeys { token, users }

class AppCache {
  AppCache._();
  static AppCache instance = AppCache._();

  Future<void> setUp() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  late SharedPreferences sharedPreferences;
}
