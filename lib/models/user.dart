import 'package:flutter/material.dart';

class User {
  String username;
  String token;
  String usertype;
  String organization;

  User({
    required this.username,
    required this.token,
    required this.usertype,
    required this.organization,
  });

  static User fromJson(Map<String, dynamic> json) => User(
        username: json['username'],
        token: json['token'],
        usertype: json['usertype'],
        organization: json['organization'],
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'token': token,
        'usertype': usertype,
        'organization': organization,
      };
}
