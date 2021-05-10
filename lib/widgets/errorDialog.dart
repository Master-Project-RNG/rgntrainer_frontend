import 'package:flutter/material.dart';

class SelfMadeErrorDialog {
  static final SelfMadeErrorDialog _selfMadeErrorDialog =
      SelfMadeErrorDialog._internal();

  factory SelfMadeErrorDialog() {
    return _selfMadeErrorDialog;
  }

  SelfMadeErrorDialog._internal();

  void showErrorDialog(String message, var context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Fehler!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay!'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
