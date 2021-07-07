import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rgntrainer_frontend/host.dart';
import 'package:rgntrainer_frontend/models/bureau_results_model.dart';

class BureauResultsProvider with ChangeNotifier {
  var activeHost = Host().getActiveHost();

  List<BureauResults> _bureauResults = [];

  List<BureauResults> get bureauResults {
    return _bureauResults;
  }

  Future<List<BureauResults>> getBureauResults(token) async {
    var url = Uri.parse('${activeHost}/getTotalResults');
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
      List<BureauResults> _result = [];
      final List<dynamic> _temp = jsonResponse;
      _temp.forEach((test) {
        final Map<String, dynamic> _temp2 = test;
        final BureauResults userResults = BureauResults.fromJson(_temp2);
        _result.add(userResults);
      });
      _bureauResults = _result;
      return _bureauResults;
    } else {
      throw Exception('Failed to load user results');
    }
  }
}
