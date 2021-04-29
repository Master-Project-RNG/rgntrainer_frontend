import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/models/http_exception.dart';
import 'package:rgntrainer_frontend/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserResultsProvider with ChangeNotifier {
  Future<void> getUserResults(name) async {
    final url = 'http://localhost:8080/getUserResults?number=%2B41765184147';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
      );
      final Map<String, dynamic> responseData = json.decode(response.body);
      /* if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      } --> Dazu ist nichts in der DB 
      final User newUser = User(
        username: responseData['username'],
        password: responseData['password'],
      );
      return newUser;*/
    } catch (error) {
      throw error;
    }
  }
}
