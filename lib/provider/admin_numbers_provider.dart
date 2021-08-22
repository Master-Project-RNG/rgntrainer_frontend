import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rgntrainer_frontend/host.dart';
import 'package:rgntrainer_frontend/models/numbers_model.dart';
import 'package:rgntrainer_frontend/widgets/error_dialog.dart';

class NumbersProvider with ChangeNotifier {
  String activeHost = Host().getActiveHost();

  List<Number> _nummern = [];

  List<Number> get bureauResults {
    return _nummern;
  }

  int get numbersTotal {
    return _nummern.length;
  }

  ///Create Users!

  ///Read Users!
  Future<void> createUser(
    String? token,
    String number,
    String bureau,
    String department,
    String firstName,
    String lastName,
    String email,
    BuildContext ctx,
  ) async {
    final url = Uri.parse('$activeHost/createUser');
    if (!isBureau()) {
      return SelfMadeErrorDialog()
          .showErrorDialog("Dieses Büro gibt es nicht!", ctx);
    }
    final response = await post(
      url,
      headers: {
        "content-type": "application/json",
      },
      body: json.encode({
        "token": token,
        "number": "+234234",
        "bureau": "Hauptamt",
        "department": "Sport",
        "firstname": "basdfet",
        "lastname": "Meier",
        "email": "hans.huber@sdfsdfg.ch"
      }),
    );
    if (response.statusCode == 200) {
      print(response.body);
    } else {
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
      print(response.body);
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
      throw Exception('Failed to load getTotalResults');
    }
  }

  ///Update Users!

  ///Delete Users! (Out of scope)

  bool isBureau() {
    return false;
  }
}
