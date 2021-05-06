import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rgntrainer_frontend/host.dart';
import 'package:rgntrainer_frontend/models/user.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  var activeHost = Host().getActiveHost();

  Future<void> _authenticate(String? username, String? password) async {
    final url = '${activeHost}/login';
    var uriUrl = Uri.parse(url);
    try {
      post(
        uriUrl,
        headers: {
          "Content-Type": "application/json",
        },
        body: {
          'username': username,
          'password': password,
        },
      ).then(
        (response) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          final User newUser = User(
            username: responseData['username'].toString(),
            password: responseData['password'].toString(),
          );
        },
      );
      /* if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      } --> Dazu ist nichts in der DB */

    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String? username, String? password) async {
    return _authenticate(username, password);
  }
}
