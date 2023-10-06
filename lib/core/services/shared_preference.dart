import 'package:shared_preferences/shared_preferences.dart';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class SharedPreference {
  static Future setString({String? key, String? value}) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(key!, value!);
  }

  static Future<String?> getString({String? key}) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(key!);
  }

  static Future clear() async {
    final SharedPreferences prefs = await _prefs;
    prefs.clear();
  }
}
