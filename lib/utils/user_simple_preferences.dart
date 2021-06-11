import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserSimplePreferences {
  static late SharedPreferences _preferences;

  static const _keyUserToken = "userToken";
  static const _keyUser = "user";

  static User myUser = User.init();

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUserToken(String token) async =>
      await _preferences.setString(_keyUserToken, token);

  static String? getUserToken() {
    if (_preferences.getString(_keyUserToken) == null) {
      return null;
    } else {
      return _preferences.getString(_keyUserToken);
    }
  }

  static Future setUser(User user) async {
    final json = jsonEncode(user.toJson());

    await _preferences.setString(_keyUser, json);
  }

  static Future resetUser() async {
    final json = jsonEncode(User.init().toJson());

    await _preferences.setString(_keyUser, json);
  }

  static User getUser() {
    final json = _preferences.getString(_keyUser);

    return json == null ? myUser : User.fromJson(jsonDecode(json));
  }
}
