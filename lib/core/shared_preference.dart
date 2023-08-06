import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static Future<SharedPreferences> _init() async {
    return await SharedPreferences.getInstance();
  }

  static SharedPreferences? _sharedPrefs;
  static Future<SharedPreferences> get _prefs async {
    return _sharedPrefs ??= await _init();
  }

  static Future<String?> getUserToken() async{
    return await getString('token');
  }

  static Future<bool> setString(String key, String value) async{
    return await (await _prefs).setString(key, value);
  }

  static  Future<String?>? getString(String key) async{
    return (await _prefs).getString(key);
  }
}
