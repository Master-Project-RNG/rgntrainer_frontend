import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:rgntrainer_frontend/host.dart';
import 'package:rgntrainer_frontend/models/numbers_model.dart';
import 'package:rgntrainer_frontend/widgets/error_dialog.dart';

class NumbersProvider with ChangeNotifier {
  String activeHost = Host().getActiveHost();
  static final _log = Logger("NumbersProvider");

  List<Number> _nummern = [];

  List<String> _bureauNames = [];

  List<Number> get bureauResults {
    return _nummern;
  }

  int get numbersTotal {
    return _nummern.length;
  }

  ///Create Users!
  Future<void> createUser({
    required String token,
    required String number,
    required String bureau,
    required List<String> allBureaus,
    required String department,
    required String firstName,
    required String lastName,
    required String email,
    required BuildContext ctx,
  }) async {
    final url = Uri.parse('$activeHost/createUser');
    if (!allBureaus.contains(bureau)) {
      return SelfMadeErrorDialog.showErrorDialog(
          message: "Dieses Büro gibt es nicht!", context: ctx);
    }
    final response = await post(
      url,
      headers: {
        "content-type": "application/json",
      },
      body: json.encode({
        "token": token,
        "number": number,
        "bureau": bureau,
        "department": department,
        "firstname": firstName,
        "lastname": lastName,
        "email": email
      }),
    );
    if (response.statusCode == 200) {
      _log.info("API CALL: /createUser, statusCode == 200");
    } else {
      SelfMadeErrorDialog.showErrorDialog(
          message: response.body.toString(), context: ctx);
      _log.warning("API CALL: /createUser failed!");
      throw Exception('Failed to create User!');
    }
  }

  ///Read Users!
  Future<List<Number>> getAllUsersNumbers(String? token) async {
    final url = Uri.parse('$activeHost/getAllUsers');
    final response = await post(
      url,
      headers: {
        "content-type": "application/json",
      },
      body: json.encode({
        'token': token,
      }),
    );
    if (response.statusCode == 200) {
      _log.info("API CALL: /getAllUsers, statusCode == 200");
      final dynamic jsonResponse = jsonDecode(response.body);
      final List<Number> _result = [];
      final List<dynamic> _temp = jsonResponse as List<dynamic>;
      // ignore: avoid_function_literals_in_foreach_calls
      _temp.forEach((element) {
        _result.add(Number.fromJson(element as Map<String, dynamic>));
      });
      _nummern = _result;
      return _result;
    } else {
      _log.warning("API CALL: /getAllUsers, failed!");
      throw Exception('Failed to load getTotalResults');
    }
  }

  ///Update Users!
  Future<void> updateUser({
    required String token,
    required String basepool_id,
    required String user_id,
    required String department,
    required String firstName,
    required String lastName,
    required String email,
    required BuildContext ctx,
  }) async {
    final url = Uri.parse('$activeHost/updateUser');
    final response = await post(
      url,
      headers: {
        "content-type": "application/json",
      },
      body: json.encode({
        "token": token,
        "basepool_id": basepool_id,
        "user_id": user_id,
        "department": department,
        "firstname": firstName,
        "lastname": lastName,
        "email": email
      }),
    );
    if (response.statusCode == 200) {
      _log.info("API CALL: /updateUser, statusCode == 200");
    } else {
      _log.warning("API CALL: /updateUser failed!");
      throw Exception('Failed to update User!');
    }
  }

  ///Set user state (Activate/Deactivate Users)!
  Future<void> setUserState({
    required String token,
    required String basepool_id,
    required bool userState,
  }) async {
    final url = Uri.parse('$activeHost/setUserState');
    final response = await post(
      url,
      headers: {
        "content-type": "application/json",
      },
      body: json.encode({
        "token": token,
        "basepool_id": basepool_id,
        "active": userState,
      }),
    );
    if (response.statusCode == 200) {
      _log.info("API CALL: /setUserState, statusCode == 200");
    } else {
      _log.warning("API CALL: /setUserState failed!");
      throw Exception('Failed to setUserState!');
    }
  }
}
