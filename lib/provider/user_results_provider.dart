import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rgntrainer_frontend/host.dart';
import 'package:rgntrainer_frontend/models/user_results_model.dart';

class UserResultsProvider with ChangeNotifier {
  var activeHost = Host().getActiveHost();

  List<UserResults> _userResults = [];
  bool _isLoading = false;

  List<UserResults> get userResults {
    return _userResults;
  }

  Future getUserResults(token) async {
    _isLoading = true;
    var url = Uri.parse('${activeHost}/getUserResults');
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
      var jsonResponse = jsonDecode(response.body);
      debugPrint(jsonResponse.toString());
      List<UserResults> _result = [];
      final List<dynamic> _temp = jsonResponse;
      _temp.forEach((test) {
        final Map<String, dynamic> _temp2 = test;
        final UserResults userResults = UserResults.fromJson(_temp2);
        _result.add(userResults);
      });
      _userResults = _result;
      _isLoading = false;
    } else {
      throw Exception('Failed to load user results');
    }
  }
}
