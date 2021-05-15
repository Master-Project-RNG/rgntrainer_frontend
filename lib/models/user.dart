import 'package:flutter/material.dart';
import 'package:rgntrainer_frontend/models/getOpeningHours.dart';

class User {
  String username;
  String token;
  String usertype;
  String organization;
  List<OpeningHours>? openingHours = [];
  String greetingConfiguration;

  factory User.init() {
    return User(
        username: "none",
        organization: "none",
        token: "none",
        usertype: "none",
        openingHours: [],
        greetingConfiguration: "none");
  }

  User({
    required this.username,
    required this.token,
    required this.usertype,
    required this.organization,
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
        username: json['username'].toString(),
        token: json['token'].toString(),
        usertype: json['usertype'].toString(),
        organization: json['organization'].toString(),
        openingHours: openingHoursList,
        greetingConfiguration: json['greetingConfiguration'].toString());
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'token': token,
        'usertype': usertype,
        'organization': organization,
        'openingHours': openingHours,
        'greetingConfiguration': greetingConfiguration,
      };
}
