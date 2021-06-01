import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/models/getOpeningHours.dart';

class User {
  String? username;
  String? token;
  String? usertype;
  String? organization;
  bool activeOpeningHours;
  List<OpeningHours>? openingHours = [];
  String? greetingConfiguration;

  factory User.init() {
    return User(
        username: null,
        organization: null,
        token: null,
        usertype: null,
        activeOpeningHours: false,
        openingHours: null,
        greetingConfiguration: null);
  }

  User({
    required this.username,
    required this.token,
    required this.usertype,
    required this.organization,
    required this.activeOpeningHours,
    this.openingHours,
    required this.greetingConfiguration,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<OpeningHours> openingHoursList = [];
    if (json['openingHours'] != null) {
      var list = json['openingHours'] as List;
      print(list.runtimeType);
      openingHoursList = list.map((i) => OpeningHours.fromJson(i)).toList();
    }

    return User(
        username: json['username'],
        token: json['token'],
        usertype: json['usertype'],
        activeOpeningHours: json['activeOpeningHours'],
        organization: json['organization'],
        openingHours: openingHoursList,
        greetingConfiguration: json['greetingConfiguration']);
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'token': token,
        'usertype': usertype,
        'activeOpeningHours': activeOpeningHours,
        'organization': organization,
        'openingHours': openingHours,
        'greetingConfiguration': greetingConfiguration,
      };
}
