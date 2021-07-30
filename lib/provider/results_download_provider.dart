import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rgntrainer_frontend/host.dart';
import 'package:rgntrainer_frontend/models/bureau_results_model.dart';

class DownloadResultsProvider with ChangeNotifier {
  String activeHost = Host().getActiveHost();

  //download
  Future<void> getExcelResults(String? token) async {
    final url = Uri.parse('$activeHost/downloadResults');
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

  Future<void> getJsonResults(
      String? token, List<BureauResults> bureauResults) async {
    final String jsonString = bureauResultsToJson(bureauResults);
    final blob = Blob([jsonString], "application/json");
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
