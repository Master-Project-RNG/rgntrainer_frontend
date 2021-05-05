import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/host.dart';
import 'package:rgntrainer_frontend/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  var activeHost = Host().getActiveHost();

  Future<void> _authenticate(String username, String password) async {
    final url = '${activeHost}/login';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
        body: json.encode(
          {
            'username': username,
            'password': password,
          },
        ),
      );
      final Map<String, dynamic> responseData = json.decode(response.body);
      /* if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      } --> Dazu ist nichts in der DB */
      final User newUser = User(
        username: responseData['username'],
        password: responseData['password'],
      );
      return newUser;
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String username, String password) async {
    return _authenticate(username, password);
  }
}
