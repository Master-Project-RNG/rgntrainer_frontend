import 'package:flutter/material.dart';

class User {
  String username;
  String token;
  String usertype;
  String? openingHours;

  User({
    required this.username,
    required this.token,
    required this.usertype,
  });
}
