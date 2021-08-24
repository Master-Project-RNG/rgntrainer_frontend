import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rgntrainer_frontend/host.dart';
import 'package:rgntrainer_frontend/models/bureau_results_model.dart';
import 'package:rgntrainer_frontend/models/diagram_model.dart';

class BureauResultsProvider with ChangeNotifier {
  String activeHost = Host().getActiveHost();

  List<BureauResults> _bureauResults = [];

  List<Diagram> _diagramResults = [];

  List<String> _bureauNames = [];

  List<BureauResults> get bureauResults {
    return _bureauResults;
  }

  List<Diagram> get diagramResults {
    return _diagramResults;
  }

  List<String> get getBureauNames {
    return _bureauNames;
  }

  Future<List<BureauResults>> getBureauResults(String? token) async {
    final url = Uri.parse('$activeHost/getTotalResults');
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
      print(response.body);
      final dynamic jsonResponse = jsonDecode(response.body);
      final List<BureauResults> _result = [];
      final List<dynamic> _temp = jsonResponse as List<dynamic>;
      // ignore: avoid_function_literals_in_foreach_calls
      _temp.forEach((element) {
        final BureauResults userResults =
            BureauResults.fromJson(element as Map<String, dynamic>);
        _result.add(userResults);
      });
      _bureauResults = _result;
      return _result;
    } else {
      throw Exception('Failed to load getTotalResults');
    }
  }

  Future<List<Diagram>> getTotalResultsWeekly(
      String? token, String bureauName) async {
    final url = Uri.parse('$activeHost/getTotalResultsWeekly');
    final response = await post(
      url,
      headers: {
        "content-type": "application/json",
      },
      body: json.encode({
        'token': token,
        "bureau": bureauName,
        'overall': false,
      }),
    );
    if (response.statusCode == 200) {
      print(response.body);
      final dynamic jsonResponse = jsonDecode(response.body);
      final List<Diagram> _result = [];
      final List<dynamic> _temp = jsonResponse as List<dynamic>;
      // ignore: avoid_function_literals_in_foreach_calls
      jsonResponse.forEach((element) {
        final Diagram diagramResults =
            Diagram.fromJson(element as Map<String, dynamic>);
        _result.add(diagramResults);
      });
      _diagramResults = _result;
      return _result;
    } else {
      throw Exception('Failed to load getTotalResultsWeekly');
    }
  }

  Future<List<String>> getBureausNames(String? token) async {
    final url = Uri.parse('$activeHost/getAllBureaus');
    final response = await post(
      url,
      headers: {
        "content-type": "application/json",
      },
      body: json.encode({
        'token': token,
        'overall': true,
      }),
    );
    if (response.statusCode == 200) {
      //TODO: Sort alphabetically
      print(response.body);
      final dynamic jsonResponse = jsonDecode(response.body);
      final List<String> _result = [];
      final List<dynamic> _temp = jsonResponse as List<dynamic>;
      // ignore: avoid_function_literals_in_foreach_calls
      jsonResponse.forEach((element) {
        _result.add(element);
      });
      _bureauNames = _result;
      return _result;
    } else {
      throw Exception('Failed to load getAllBureaus');
    }
  }
}
