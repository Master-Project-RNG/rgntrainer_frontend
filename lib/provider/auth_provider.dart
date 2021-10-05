import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:rgntrainer_frontend/host.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import 'package:rgntrainer_frontend/utils/user_simple_preferences.dart';
import '../widgets/error_dialog.dart';

class AuthProvider with ChangeNotifier {
  String activeHost = Host().getActiveHost();
  static final _log = Logger("AuthProvider");

  late User currentUser;

  User get loggedInUser {
    return currentUser;
  }

  //login
  Future<void> login(
      String? username, String? password, BuildContext ctx) async {
    UserSimplePreferences.resetUser();
    return _authenticate(username!, password!,
        ctx); //return needed for redirection to correct programm flow
  }

  ///Used for [login]
  Future<void> _authenticate(
      String username, String password, BuildContext ctx) async {
    final url = '$activeHost/login';
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
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(response.body) as Map<String, dynamic>;
        currentUser = User.fromJson(responseData);
        UserSimplePreferences.setUser(currentUser);
        UserSimplePreferences.setAbfrageTabOpen(false);
        _log.info(
            "API CALL: /login, token:${currentUser.token}, statusCode == 200");
      } else {
        _log.warning("API CALL: /login failed!");
        const errorMessage = 'Login fehlgeschlagen!';
        SelfMadeErrorDialog.showErrorDialog(
            message: errorMessage, context: ctx);
      }
    } catch (error) {
      _log.warning("API CALL: /login failed!");
      const errorMessage = 'Login fehlgeschlagen!';
      SelfMadeErrorDialog.showErrorDialog(message: errorMessage, context: ctx);
    }
  }

  //Logs out the user
  Future<void> logout(String token) async {
    UserSimplePreferences.resetUser();
    final url = '$activeHost/logout';
    try {
      await http.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
        body: json.encode({
          'token': token,
        }),
      );
      _log.info("API CALL: /logout, statusCode == 200");
    } catch (error) {
      _log.warning("API CALL: /logout failed!");
      rethrow;
    }
  }

  //Changes the password
  Future<void> changePassword(BuildContext ctx, String token,
      String oldPassword, String newPassword) async {
    final url = '$activeHost/changePassword';
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
        _log.info("API CALL: /changePassword, statusCode == 200");
        showDialog(
          context: ctx,
          builder: (ctx) => AlertDialog(
            title: const Text('Erfolg!'),
            content: const Text("Passwort aktualisiert!"),
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
        _log.warning("API CALL: /changePassword failed!");
        showDialog(
          context: ctx,
          builder: (ctx) => AlertDialog(
            title: const Text('Fehler!'),
            content: const Text(
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
    } catch (error) {
      _log.warning("API CALL: /changePassword failed!");
    }
  }
}
