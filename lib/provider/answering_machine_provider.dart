import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/host.dart';
import 'package:rgntrainer_frontend/models/configuration_model.dart';
import 'package:http/http.dart' as http;
import 'package:rgntrainer_frontend/models/user_model.dart';

class AnsweringMachineProvider with ChangeNotifier {
  var activeHost = Host().getActiveHost();

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

  Future<void> getAnsweringMachineConfiguration(token) async {
    _isLoadingGetGreeting = true;

    var url = Uri.parse('${activeHost}/getResponderConfiguration');
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
      ConfigurationSummary test =
          ConfigurationSummary.fromJsonGreeting(responseData);
      debugPrint("getAnsweringMachineConfiguration:" + test.toString());
      greetingConfigurationSummary = test;
      //  if (_pickedBureauGreeting == null) {
      _pickedBureauGreeting = greetingConfigurationSummary.bureaus![0];
      //}
      //if (_pickedUserGreeting == null) {
      _pickedUserGreeting = greetingConfigurationSummary.users[0];
      // }
      _isLoadingGetGreeting = false;
      notifyListeners();
    } else {
      throw Exception('Unable to get ResponderConfiguration!');
    }
  }

  Future<void> setAnsweringMachineConfiguration(
      String token, ConfigurationSummary _greetingConfiguration) async {
    var url = Uri.parse('${activeHost}/setResponderConfiguration');

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
      debugPrint("setAnsweringMachineConfiguration: " + response.toString());
    } else {
      throw Exception('Unable to set GreetingConfiguration!');
    }
  }

  final Map<String, dynamic> _greetingData = {};

  Map<String, dynamic> get getGreetingData {
    return _greetingData;
  }
}
