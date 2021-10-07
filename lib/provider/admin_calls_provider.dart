import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:rgntrainer_frontend/models/call_range.dart';
import 'package:rgntrainer_frontend/models/configuration_model.dart';
import 'package:rgntrainer_frontend/models/status_model.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import '../host.dart';

class AdminCallsProvider with ChangeNotifier {
  final String activeHost = Host().getActiveHost();
  static final _log = Logger("AdminCallsProvider");

  ConfigurationSummary greetingConfigurationSummary =
      ConfigurationSummary.init();

  ConfigurationSummary get getGreetingConfigurationSummary {
    return greetingConfigurationSummary;
  }

  //get trainer status ()
  Future<Status> getTrainerStatus(String token) async {
    final url = Uri.parse('$activeHost/status');
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
      _log.info(
          "API CALL: /status == ${Status.fromJson(responseData).status}, statusCode == 200");
      return Status.fromJson(responseData);
    } else {
      _log.warning("API CALL: /status failed!");
      throw Exception('Unable to get Status!');
    }
  }

  //getCallRange
  Future<CallRange> getCallRange(String token) async {
    final url = Uri.parse('$activeHost/getCallRange');
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
      _log.info("API CALL: /getCallRange, statusCode == 200");
      final Map<String, dynamic> responseData =
          json.decode(response.body) as Map<String, dynamic>;
      return CallRange.fromJson(responseData);
    } else {
      _log.warning("API CALL: /getCallRange failed!");
      throw Exception('Unable to getCallRange!');
    }
  }

  //setCallRange
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
      _log.info("API CALL: /setCallRange, statusCode == 200");
    } else {
      _log.warning("API CALL: /setCallRange failed!");
      throw Exception('Unable to setCallRange!');
    }
  }

  //start the trainer
  Future<Status> startTrainer(String token) async {
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
      _log.info("API CALL: /start, statusCode == 200");
      return getTrainerStatus(token);
    } catch (error) {
      _log.warning("API CALL: /start failed!");
      rethrow;
    }
  }

  //stop the trainer
  Future<Status> stopTrainer(String token) async {
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
      _log.info("API CALL: /stop, statusCode == 200");
      return getTrainerStatus(token);
    } catch (error) {
      _log.warning("API CALL: /stop failed!");
      rethrow;
    }
  }

  //download
  Future<void> getResults(String token) async {
    final url = Uri.parse('$activeHost/downloadResults');
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
      _log.info("API CALL: /downloadResults, statusCode == 200");
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
      _log.warning("API CALL: /downloadResults failed!");
      throw Exception('Unable to download results!');
    }
  }

  //getOpeningHours
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
      _log.info("API CALL: /getOpeningHours, statusCode == 200");
      final Map<String, dynamic> responseData =
          json.decode(response.body) as Map<String, dynamic>;
      final ConfigurationSummary result =
          ConfigurationSummary.fromJsonOpeningHours(responseData);
      return result;
    } else {
      _log.warning("API CALL: /getOpeningHours failed!");
      throw Exception('Unable to get OpeningHours!');
    }
  }

  //setOpeningHours
  Future<void> setOpeningHours(
      String token, ConfigurationSummary _openingHours) async {
    final url = Uri.parse('$activeHost/setOpeningHours');
    final openingJson = jsonEncode(_openingHours.toJsonOpeningHours(token));
    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
      },
      body: openingJson,
    );
    if (response.statusCode == 200) {
      _log.info("API CALL: /setOpeningHours, statusCode == 200");
    } else {
      _log.warning("API CALL: /setOpeningHours failed!");
      throw Exception('Unable to set OpeningHours!');
    }
  }

  bool _isLoadingGetGreeting = false;
  Bureaus _pickedBureauGreeting = Bureaus.init();
  User _pickedUserGreeting = User.init();

  bool get isLoadingGetGreeting {
    return _isLoadingGetGreeting;
  }

  Bureaus get getPickedBureauGreeting {
    return _pickedBureauGreeting;
  }

  Bureaus setPickedBureauGreeting(Bureaus b) {
    return _pickedBureauGreeting = b;
  }

  User get getPickedUserGreeting {
    return _pickedUserGreeting;
  }

  User setPickedUserGreeting(User u) {
    return _pickedUserGreeting = u;
  }

  //getGreetingConfiguration
  Future<void> getGreetingConfiguration(String token) async {
    _isLoadingGetGreeting = true;

    final url = Uri.parse('$activeHost/getGreetingConfiguration');
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
      _log.info("API CALL: /getGreetingConfiguration, statusCode == 200");
      final Map<String, dynamic> responseData =
          json.decode(response.body) as Map<String, dynamic>;
      greetingConfigurationSummary =
          ConfigurationSummary.fromJsonGreeting(responseData);
      _pickedBureauGreeting = greetingConfigurationSummary.bureaus![0];
      _pickedUserGreeting = greetingConfigurationSummary.users[0];
      _isLoadingGetGreeting = false;
      notifyListeners();
    } else {
      _log.warning("API CALL: /getGreetingConfiguration failed!");
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
      _log.info("API CALL: /setGreetingConfiguration, statusCode == 200");
    } else {
      _log.warning("API CALL: /setGreetingConfiguration failed!");
      throw Exception('Unable to set GreetingConfiguration!');
    }
  }

  /// Used in [GreetingTabWidget]
  final Map<String, dynamic> _greetingData = {};

  /// Used in [GreetingTabWidget]
  Map<String, dynamic> get getGreetingData {
    return _greetingData;
  }
}
