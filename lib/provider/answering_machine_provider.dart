import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:rgntrainer_frontend/host.dart';
import 'package:rgntrainer_frontend/models/configuration_model.dart';
import 'package:http/http.dart' as http;
import 'package:rgntrainer_frontend/models/user_model.dart';

class AnsweringMachineProvider with ChangeNotifier {
  String activeHost = Host().getActiveHost();
  static final _log = Logger("AnsweringMachineProvider");

  ConfigurationSummary greetingConfigurationSummary =
      ConfigurationSummary.init();

  ConfigurationSummary get getGreetingConfigurationSummary {
    return greetingConfigurationSummary;
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

  Future<void> getAnsweringMachineConfiguration(String token) async {
    _isLoadingGetGreeting = true;
    final url = Uri.parse('$activeHost/getResponderConfiguration');
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
      _log.info("API CALL: /getResponderConfiguration, statusCode == 200");
      final Map<String, dynamic> responseData =
          json.decode(response.body) as Map<String, dynamic>;
      greetingConfigurationSummary =
          ConfigurationSummary.fromJsonGreeting(responseData);
      _pickedBureauGreeting = greetingConfigurationSummary.bureaus![0];
      _pickedUserGreeting = greetingConfigurationSummary.users[0];
      _isLoadingGetGreeting = false;
      notifyListeners();
    } else {
      _log.warning("API CALL: /getResponderConfiguration failed!");
      throw Exception('Unable to get ResponderConfiguration!');
    }
  }

  Future<void> setAnsweringMachineConfiguration(
      String token, ConfigurationSummary _greetingConfiguration) async {
    final url = Uri.parse('$activeHost/setResponderConfiguration');
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
      _log.info("API CALL: /setResponderConfiguration, statusCode == 200");
    } else {
      _log.warning("API CALL: /setResponderConfiguration failed!");
      throw Exception('Unable to set GreetingConfiguration!');
    }
  }

  final Map<String, dynamic> _greetingData = {};

  Map<String, dynamic> get getGreetingData {
    return _greetingData;
  }
}
