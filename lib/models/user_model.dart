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

  /// Factory method to create a dart object out of a json
  factory User.fromJson(Map<String, dynamic> json) {
    List<OpeningHours> openingHoursList = [];
    if (json['openingHours'] != null) {
      var list = json['openingHours'] as List;
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
