import 'dart:convert';
import 'dart:html';

import 'package:url_launcher/url_launcher.dart';

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
  startTrainer(intervalSeconds) {}

  //stop the trainer
  stopTrainer() {}

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
