import 'package:rgntrainer_frontend/models/configuration_model.dart';

class User {
  String? username;
  String? token;
  String? usertype;
  String? organization;
  bool? activeOpeningHours;
  List<OpeningHours>? openingHours = [];
  bool? activeGreetingConfiguration;
  GreetingConfiguration? greetingConfiguration;

  factory User.init() {
    return User(
      username: null,
      organization: null,
      token: null,
      usertype: null,
      activeOpeningHours: false,
      openingHours: null,
      activeGreetingConfiguration: null,
      greetingConfiguration: null,
    );
  }

  User({
    required this.username,
    required this.token,
    required this.usertype,
    required this.organization,
    this.activeOpeningHours,
    this.openingHours,
    this.activeGreetingConfiguration,
    this.greetingConfiguration,
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
      activeGreetingConfiguration: json['activeGreetingConfiguration'],
      greetingConfiguration: json["greetingConfiguration"] != null
          ? GreetingConfiguration.fromJson(json["greetingConfiguration"])
          : null,
    );
  }

  factory User.fromMockup() {
    return User(
      username: "Raphael",
      token: "ea6b7552-c235-41d2-9a86-5115dac89bb5",
      usertype: "admin",
      activeOpeningHours: false,
      organization: "Rothenburg",
      openingHours: [],
      activeGreetingConfiguration: false,
      greetingConfiguration: null,
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'token': token,
        'usertype': usertype,
        'activeOpeningHours': activeOpeningHours!,
        'organization': organization,
        'openingHours': openingHours,
        'activeGreetingConfiguration': activeGreetingConfiguration,
        'greetingConfiguration': greetingConfiguration?.toJson(),
      };
}
