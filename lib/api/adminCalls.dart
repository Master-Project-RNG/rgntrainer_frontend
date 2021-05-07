import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../host.dart';

class AdminCalls with ChangeNotifier {
  var activeHost = Host().getActiveHost();

  //get trainer status ()
  //--- currently unused ---
  Future<bool> getTrainerStatus(token) async {
    var url = Uri.parse('${activeHost}/status');
    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
      },
      body: json.encode({
        'token': token,
      }),
    );
    if (response.statusCode == 200) {
      String responseStatus = response.body;
      bool status = responseStatus.toLowerCase() == 'true';
      print("getTrainerStatus:" + status.toString());
      return status;
    } else {
      throw Exception('Unable to get Status!');
    }
  }

  //getIntervalSeconds
  //--- currently unused ---
  Future<int> getIntervalSeconds() async {
    var url = Uri.parse('${activeHost}/getIntervalSeconds');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      int responseIntervalSeconds = int.parse(response.body);
      print("getTrainerStatus:" + responseIntervalSeconds.toString());
      return responseIntervalSeconds;
    } else {
      throw Exception('Unable to get IntervalSeconds!');
    }
  }

  //start the trainer
  Future<void> startTrainer(intervalSeconds, token) async {
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
      print("startTrainer:" + response.body);
      getTrainerStatus(token);
    } catch (error) {
      throw error;
    }
  }

  //stop the trainer
  Future<void> stopTrainer(token) async {
    final url = '${activeHost}/stop';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
      );
      print("stopTrainer:" + response.body);
      getTrainerStatus(token);
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
      document.body!.append(anchor);
      anchor.click();
      anchor.remove();
    } else {
      throw Exception('Unable to get Status!');
    }
  }
}
