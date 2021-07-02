import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rgntrainer_frontend/host.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';
import 'dart:convert';
import '../widgets/error_dialog.dart';

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
      currentUser = User.fromJson(responseData);
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
    UserSimplePreferences.resetUser();
    return _authenticate(username!, password!, ctx);
  }

  Future<void> logout(token) async {
    UserSimplePreferences.resetUser();
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
      //Logout successful!
      debugPrint(response.toString());
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> changePassword(ctx, token, oldPassword, newPassword) async {
    // UserSimplePreferences.resetUser(); //Login required after password change or just
    final url = '${activeHost}/changePassword';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
        body: json.encode(
          {
            'token': token,
            'oldPassword': oldPassword,
            'newPassword': newPassword,
          },
        ),
      );
      if (response.statusCode == 200) {
        showDialog(
          context: ctx,
          builder: (ctx) => AlertDialog(
            title: const Text('Erfolg!'),
            content: Text("Passwort aktualisiert!"),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Schliessen'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: ctx,
          builder: (ctx) => AlertDialog(
            title: const Text('Fehler!'),
            content: Text(
                "Passwort konnte nicht aktualisiert werden! Wurde das alte Passwort korrekt eingegeben?"),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Schliessen'),
              ),
            ],
          ),
        );
      }
      debugPrint(response.toString());
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
