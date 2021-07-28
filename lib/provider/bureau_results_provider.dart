import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rgntrainer_frontend/host.dart';
import 'package:rgntrainer_frontend/models/bureau_results_model.dart';
import 'dart:html';

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

  //download
  Future<void> getExcelResults(token) async {
    var url = Uri.parse('${activeHost}/downloadResults');
    final response = await post(
      url,
      headers: {
        "content-type": "application/json",
      },
      body: json.encode(
        {
          'token': token,
        },
      ),
    );
    if (response.statusCode == 200) {
      final blob = Blob([response.bodyBytes],
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      final url = Url.createObjectUrlFromBlob(blob);

      final anchor = AnchorElement(href: url)..target = 'blank';
      // add the name
      anchor.download = 'resultate.xlsx';
      // trigger download
      document.body!.append(anchor);
      anchor.click();
      anchor.remove();
    } else {
      throw Exception('Unable to download results!');
    }
  }

  Future<void> getJsonResults(token) async {
    String test = bureauResultsToJson(_bureauResults);
    var blob = new Blob([test], "application/json");
    final url = Url.createObjectUrlFromBlob(blob);

    final anchor = AnchorElement(href: url)..target = 'blank';
    // add the name
    anchor.download = 'resultate.json';
    // trigger download
    document.body!.append(anchor);
    anchor.click();
    anchor.remove();
  }

  String bureauResultsToJson(List<BureauResults> data) => json
      .encode(List<dynamic>.from(data.map((x) => x.bureauResultstoJson2())));
}
