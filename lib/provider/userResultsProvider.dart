import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/models/user.dart';

import 'package:http/http.dart' as http;

import 'package:rgntrainer_frontend/models/userResults.dart';

class UserResultsProvider with ChangeNotifier {
  User test;

  Future<UserResults> getUserResults(name) async {
    var url =
        Uri.https('localhost:8080', '/getUserResults?number=%2B41765184147');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      return UserResults.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
    /* if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      } --> Dazu ist nichts in der DB 
      final User newUser = User(
        username: responseData['username'],
        password: responseData['password'],
      );
      return newUser;*/
  }
}
