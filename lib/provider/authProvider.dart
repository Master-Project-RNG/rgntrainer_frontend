import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rgntrainer_frontend/host.dart';
import 'package:rgntrainer_frontend/models/user.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';
import 'dart:convert';
import '../widgets/errorDialog.dart';

class AuthProvider with ChangeNotifier {
  var activeHost = Host().getActiveHost();
  late User currentUser;

  User get loggedInUser {
    return currentUser;
  }

  Future<void> _authenticate(String username, String password, ctx) async {
    final url = '${activeHost}/login';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      final Map<String, dynamic> responseData = json.decode(response.body);
      currentUser = User(
          username: responseData['username'].toString(),
          token: responseData['token'].toString(),
          usertype: responseData['usertype'].toString(),
          organization: responseData['organization'].toString());
      UserSimplePreferences.setUserToken(responseData['token'].toString());
      UserSimplePreferences.setUser(currentUser);
      /* if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      } --> Dazu ist nichts in der DB */
    } catch (error) {
      const errorMessage = 'Login fehlgeschlagen!';
      SelfMadeErrorDialog().showErrorDialog(errorMessage, ctx);
      debugPrint(error.toString());
    }
  }

  Future<void> login(String? username, String? password, var ctx) async {
    return _authenticate(username!, password!, ctx);
  }

  Future<void> logout(token) async {
    final url = '${activeHost}/logout';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
        body: json.encode({
          'token': token,
        }),
      );
      UserSimplePreferences.resetUser();
      //Logout successful!
      debugPrint(response.toString());
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
