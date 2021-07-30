import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rgntrainer_frontend/models/callRange.dart';
import 'package:rgntrainer_frontend/models/configuration_model.dart';
import 'package:rgntrainer_frontend/models/user_model.dart';
import '../host.dart';

class AdminCallsProvider with ChangeNotifier {
  var activeHost = Host().getActiveHost();

  ConfigurationSummary greetingConfigurationSummary =
      ConfigurationSummary.init();

  ConfigurationSummary get getGreetingConfigurationSummary {
    return greetingConfigurationSummary;
  }

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

  //getCallRange
  Future<CallRange> getCallRange(token) async {
    var url = Uri.parse('${activeHost}/getCallRange');
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
      return CallRange.fromJson(responseData);
    } else {
      throw Exception('Unable to getCallRange!');
    }
  }

  //getCallRange
  Future<void> setCallRange(token, CallRange callRange) async {
    var url = Uri.parse('${activeHost}/setCallRange');

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
  Future<void> startTrainer(token) async {
    final url = '${activeHost}/start';
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

  Future<ConfigurationSummary> getOpeningHours(token) async {
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
      ConfigurationSummary test =
          ConfigurationSummary.fromJsonOpeningHours(responseData);
      debugPrint(test.toString());
      return test;
    } else {
      throw Exception('Unable to get OpeningHours!');
    }
  }

  Future<void> setOpeningHours(
      token, ConfigurationSummary _openingHours) async {
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
      ConfigurationSummary test =
          ConfigurationSummary.fromJsonGreeting(responseData);
      debugPrint(test.toString());
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
      throw Exception('Unable to get GreetingConfiguration!');
    }
  }

  Future<void> setGreetingConfiguration(
      String token, ConfigurationSummary _greetingConfiguration) async {
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

  final Map<String, dynamic> _greetingData = {};

  Map<String, dynamic> get getGreetingData {
    return _greetingData;
  }
}
