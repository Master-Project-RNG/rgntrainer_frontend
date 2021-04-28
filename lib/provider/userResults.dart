import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/models/http_exception.dart';
import 'package:rgntrainer_frontend/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserResultsProvider with ChangeNotifier {
  Future<void> getUserResults(name) async {
    final url = 'http://localhost:8080/getUserResults';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
        body: json.encode(
          {
            'name': name,
          },
        ),
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
