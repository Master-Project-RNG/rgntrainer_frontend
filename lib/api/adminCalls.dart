import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../host.dart';

class AdminCalls with ChangeNotifier {
  var activeHost = Host().getActiveHost();

  //get trainer status
  Future<bool> getTrainerStatus() async {
    var url = Uri.parse('${activeHost}/status');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      String responseStatus = response.body;
      bool status = responseStatus.toLowerCase() == 'true';
      return status;
    } else {
      throw Exception('Unable to get Status!');
    }
  }

  //getIntervalSeconds
  getIntervalSeconds() {}

  //start the trainer
  Future<void> startTrainer(intervalSeconds) async {
    final url = '${activeHost}/start?intervalSeconds=${intervalSeconds}';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
        body: json.encode(
          {
            'intervalSeconds': intervalSeconds,
          },
        ),
      );
      //final Map<String, dynamic> responseData = json.decode(response.body);
      /* if (responseData['error'] != null) {*/
    } catch (error) {
      throw error;
    }
  }

  //stop the trainer
  Future<void> stopTrainer() async {
    final url = '${activeHost}/stop';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
      );
      print(response);
      //final Map<String, dynamic> responseData = json.decode(response.body);
    } catch (error) {
      throw error;
    }
  }

  //download results
  getResults() async {
    //TODO: Change URL
    var url = Uri.parse('${activeHost}/downloadResults');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final blob = Blob([response.bodyBytes],
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      final url = Url.createObjectUrlFromBlob(blob);

      final anchor = AnchorElement(href: url)..target = 'blank';
      // add the name
      anchor.download = 'resultate.xlsx';
      // trigger download
      document.body.append(anchor);
      anchor.click();
      anchor.remove();
    } else {
      throw Exception('Unable to get Status!');
    }
  }
}
