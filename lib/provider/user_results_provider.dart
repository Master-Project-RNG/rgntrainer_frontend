import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rgntrainer_frontend/host.dart';
import 'package:rgntrainer_frontend/models/user_results_model.dart';

class UserResultsProvider with ChangeNotifier {
  String activeHost = Host().getActiveHost();

  List<UserResults> _userResults = [];

  List<UserResults> get userResults {
    return _userResults;
  }

  Future getUserResults(String token) async {
    final url = Uri.parse('$activeHost/getUserResults');
    final response = await post(
      url,
      headers: {
        "content-type": "application/json",
      },
      body: json.encode({
        'token': token,
      }),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      debugPrint("getUserResults: $jsonResponse");
      final List<UserResults> _result = [];
      final List<dynamic> _temp = jsonResponse as List<dynamic>;
      _temp.forEach((test) {
        final Map<String, dynamic> _temp2 = test as Map<String, dynamic>;
        final UserResults userResults = UserResults.fromJson(_temp2);
        _result.add(userResults);
      });
      _userResults = _result;
    } else {
      throw Exception('Failed to load user results');
    }
  }
}
