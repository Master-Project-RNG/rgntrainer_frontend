import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static late SharedPreferences _preferences;

  static const _keyUserToken = "userToken";

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUserToken(String token) async =>
      await _preferences.setString(_keyUserToken, token);

  static String? getUserToken() {
    if (_preferences.getString(_keyUserToken) == null) {
      return "none";
    } else
      return _preferences.getString(_keyUserToken);
  }
}
