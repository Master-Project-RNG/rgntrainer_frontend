import 'package:flutter/material.dart';

class UserResults {
  final String number;
  final String bureau;
  final String date;
  final String saidCity;
  final String saidName;
  final String saidGreeting;
  final String reached;
  final String callCompleted;
  final String responderStarted;

  UserResults(
      {@required this.number,
      @required this.bureau,
      @required this.date,
      @required this.saidCity,
      @required this.saidName,
      @required this.saidGreeting,
      @required this.reached,
      @required this.callCompleted,
      @required this.responderStarted});

  factory UserResults.fromJson(Map<String, dynamic> json) {
    return UserResults(
      number: json['number'],
      bureau: json['bureau'],
      date: json['date'],
      saidCity: json['saidCity'],
      saidName: json['saidName'],
      saidGreeting: json['saidGreeting'],
      reached: json['reached'],
      callCompleted: json['callCompleted'],
      responderStarted: json['responderStarted'],
    );
  }
}
