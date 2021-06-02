import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rgntrainer_frontend/models/configuration_model.dart';
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
  Future<int> getIntervalSeconds(token) async {
    var url = Uri.parse('${activeHost}/getIntervalSeconds');
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
            'token': token,
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
        body: json.encode(
          {
            'token': token,
          },
        ),
      );
      print("stopTrainer:" + response.body);
      getTrainerStatus(token);
    } catch (error) {
      throw error;
    }
  }

  //download
  getResults(token) async {
    var url = Uri.parse('${activeHost}/downloadResults');
    final response = await http.post(
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

  Future<ConfigurartionSummary> getOpeningHours(token) async {
    var url = Uri.parse('${activeHost}/getOpeningHours');
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
      final Map<String, dynamic> responseData = json.decode(response.body);
      ConfigurartionSummary test =
          ConfigurartionSummary.fromJsonOpeningHours(responseData);
      debugPrint(test.toString());
      return test;
    } else {
      throw Exception('Unable to get OpeningHours!');
    }
  }

  Future<void> setOpeningHours(
      token, ConfigurartionSummary _openingHours) async {
    var url = Uri.parse('${activeHost}/setOpeningHours');

    final openingJson = jsonEncode(_openingHours.toJsonOpeningHours(token));

    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
      },
      body: openingJson,
    );
    if (response.statusCode == 200) {
      debugPrint(response.toString());
    } else {
      throw Exception('Unable to set OpeningHours!');
    }
  }

  Future<ConfigurartionSummary> getGreetingConfiguration(token) async {
    var url = Uri.parse('${activeHost}/getGreetingConfiguration');
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
      final Map<String, dynamic> responseData = json.decode(response.body);
      ConfigurartionSummary test =
          ConfigurartionSummary.fromJsonGreeting(responseData);
      debugPrint(test.toString());
      return test;
    } else {
      throw Exception('Unable to get GreetingConfiguration!');
    }
  }

  Future<void> setGreetingConfiguration(
      token, ConfigurartionSummary _greetingConfiguration) async {
    var url = Uri.parse('${activeHost}/setGreetingConfiguration');

    final openingJson =
        jsonEncode(_greetingConfiguration.toJsonGreeting(token));

    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
      },
      body: openingJson,
    );
    if (response.statusCode == 200) {
      debugPrint(response.toString());
    } else {
      throw Exception('Unable to set GreetingConfiguration!');
    }
  }
}
