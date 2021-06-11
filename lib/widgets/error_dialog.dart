import 'package:flutter/material.dart';

class SelfMadeErrorDialog {
  static final SelfMadeErrorDialog _selfMadeErrorDialog =
      SelfMadeErrorDialog._internal();

  factory SelfMadeErrorDialog() {
    return _selfMadeErrorDialog;
  }

  SelfMadeErrorDialog._internal();

  void showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Fehler!'),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Okay!'),
          ),
        ],
      ),
    );
  }
}
