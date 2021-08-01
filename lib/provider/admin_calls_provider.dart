import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rgntrainer_frontend/models/call_range.dart';
import 'package:rgntrainer_frontend/models/configuration_model.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import '../host.dart';

class AdminCallsProvider with ChangeNotifier {
  final String activeHost = Host().getActiveHost();

  ConfigurationSummary greetingConfigurationSummary =
      ConfigurationSummary.init();

  ConfigurationSummary get getGreetingConfigurationSummary {
    return greetingConfigurationSummary;
  }

  //get trainer status ()
  //--- currently unused ---
  Future<bool> getTrainerStatus(String token) async {
    var url = Uri.parse('$activeHost/status');
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
      final String responseStatus = response.body;
      final bool status = responseStatus.toLowerCase() == 'true';
      debugPrint("getTrainerStatus: $status");
      return status;
    } else {
      throw Exception('Unable to get Status!');
    }
  }

  //getCallRange
  Future<CallRange> getCallRange(String token) async {
    var url = Uri.parse('$activeHost/getCallRange');
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
      final Map<String, dynamic> responseData =
          json.decode(response.body) as Map<String, dynamic>;
      return CallRange.fromJson(responseData);
    } else {
      throw Exception('Unable to getCallRange!');
    }
  }

  //getCallRange
  Future<void> setCallRange(String token, CallRange callRange) async {
    final url = Uri.parse('$activeHost/setCallRange');

    final callRangeJson = jsonEncode(callRange.toJson(token));
    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
      },
      body: callRangeJson,
    );
    if (response.statusCode == 200) {
      debugPrint(response.toString());
    } else {
      throw Exception('Unable to getCallRange!');
    }
  }

  //start the trainer
  Future<void> startTrainer(String token) async {
    final url = '$activeHost/start';
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
      debugPrint("startTrainer: ${response.body}");
      getTrainerStatus(token);
    } catch (error) {
      throw error;
    }
  }

  //stop the trainer
  Future<void> stopTrainer(String token) async {
    final url = '$activeHost/stop';
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
      debugPrint("stopTrainer: ${response.body}");
      getTrainerStatus(token);
    } catch (error) {
      throw error;
    }
  }

  //download
  Future<void> getResults(String token) async {
    var url = Uri.parse('$activeHost/downloadResults');
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

  Future<ConfigurationSummary> getOpeningHours(String token) async {
    final url = Uri.parse('$activeHost/getOpeningHours');
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
      final Map<String, dynamic> responseData =
          json.decode(response.body) as Map<String, dynamic>;
      final ConfigurationSummary result =
          ConfigurationSummary.fromJsonOpeningHours(responseData);
      debugPrint(result.toString());
      return result;
    } else {
      throw Exception('Unable to get OpeningHours!');
    }
  }

  Future<void> setOpeningHours(
      String token, ConfigurationSummary _openingHours) async {
    var url = Uri.parse('$activeHost/setOpeningHours');

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

  bool _isLoadingGetGreeting = false;
  bool get isLoadingGetGreeting {
    return _isLoadingGetGreeting;
  }

  Bureaus _pickedBureauGreeting = Bureaus.init();
  Bureaus get getPickerBureauGreeting {
    return _pickedBureauGreeting;
  }

  Bureaus setPickerBureauGreeting(Bureaus b) {
    return _pickedBureauGreeting = b;
  }

  User _pickedUserGreeting = User.init();
  User get getPickerUserGreeting {
    return _pickedUserGreeting;
  }

  User setPickedUserGreeting(User u) {
    return _pickedUserGreeting = u;
  }

  Future<void> getGreetingConfiguration(token) async {
    _isLoadingGetGreeting = true;

    var url = Uri.parse('$activeHost/getGreetingConfiguration');
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
      final Map<String, dynamic> responseData =
          json.decode(response.body) as Map<String, dynamic>;
      ConfigurationSummary test =
          ConfigurationSummary.fromJsonGreeting(responseData);
      debugPrint(test.toString());
      greetingConfigurationSummary = test;
      _pickedBureauGreeting = greetingConfigurationSummary.bureaus![0];
      _pickedUserGreeting = greetingConfigurationSummary.users[0];
      _isLoadingGetGreeting = false;
      notifyListeners();
    } else {
      throw Exception('Unable to get GreetingConfiguration!');
    }
  }

  Future<void> setGreetingConfiguration(
      String token, ConfigurationSummary _greetingConfiguration) async {
    final url = Uri.parse('$activeHost/setGreetingConfiguration');

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

  final Map<String, dynamic> _greetingData = {};

  Map<String, dynamic> get getGreetingData {
    return _greetingData;
  }
}
