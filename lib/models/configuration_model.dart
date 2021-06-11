import 'package:rgntrainer_frontend/models/user_model.dart';

class ConfigurationSummary {
  String? name;
  List<Bureaus>? bureaus;
  List<User> users;
  List<OpeningHours>? openingHours;
  GreetingConfiguration? greetingConfiguration;

  ConfigurationSummary({
    this.greetingConfiguration,
    required this.name,
    required this.bureaus,
    required this.users,
    this.openingHours,
  });

  factory ConfigurationSummary.init() {
    return ConfigurationSummary(
        name: null,
        bureaus: [],
        users: [User.init()],
        openingHours: [
          OpeningHours.init(),
          OpeningHours.init(),
          OpeningHours.init(),
          OpeningHours.init(),
          OpeningHours.init()
        ],
        greetingConfiguration: null);
  }

  // Used for getting OpeningHours information
  factory ConfigurationSummary.fromJsonOpeningHours(Map<String, dynamic> json) {
    List<Bureaus> bureausList = [];
    if (json['bureaus'] != null) {
      var list = json['bureaus'] as List;
      print(list.runtimeType);
      bureausList = list.map((i) => Bureaus.fromJsonOpeningHours(i)).toList();
    }

    List<User> usersList = [];
    if (json['users'] != null) {
      var list2 = json['users'] as List;
      print(list2.runtimeType);
      usersList = list2.map((i) => User.fromJson(i)).toList();
    }

    List<OpeningHours> openingHoursList = [];
    if (json['openingHours'] != null) {
      var list3 = json['openingHours'] as List;
      print(list3.runtimeType);
      openingHoursList = list3.map((i) => OpeningHours.fromJson(i)).toList();
    }

    return ConfigurationSummary(
      name: json['name'],
      bureaus: bureausList,
      users: usersList,
      openingHours: openingHoursList,
      greetingConfiguration: json['greetingConfiguration'],
    );
  }

  // Used for set OpeningHours information in DB
  Map<String, dynamic> toJsonOpeningHours(token) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = token;
    data['name'] = this.name;
    if (this.bureaus != null) {
      data['bureaus'] =
          this.bureaus?.map((v) => v.toJsonOpeningHours()).toList();
    }
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    if (this.openingHours != null) {
      data['openingHours'] = this.openingHours?.map((v) => v.toJson()).toList();
    }
    return data;
  }

  // Used for getting Greeting information
  factory ConfigurationSummary.fromJsonGreeting(Map<String, dynamic> json) {
    List<Bureaus> bureausList = [];
    if (json['bureaus'] != null) {
      var list = json['bureaus'] as List;
      print(list.runtimeType);
      bureausList = list.map((i) => Bureaus.fromJsonGreeting(i)).toList();
    }

    List<User> usersList = [];
    if (json['users'] != null) {
      var list2 = json['users'] as List;
      print(list2.runtimeType);
      usersList = list2.map((i) => User.fromJson(i)).toList();
    }

    return ConfigurationSummary(
      name: json['name'],
      bureaus: bureausList,
      users: usersList,
      greetingConfiguration:
          GreetingConfiguration.fromJson(json['greetingConfiguration']),
    );
  }

  // Used for set Greeting Information in DB
  Map<String, dynamic> toJsonGreeting(token) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = token;
    data['name'] = this.name;
    if (this.bureaus != null) {
      data['bureaus'] = this.bureaus?.map((v) => v.toJsonGreeting()).toList();
    }
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    data['greetingConfiguration'] = this.greetingConfiguration;
    return data;
  }
}

class Bureaus {
  String name;
  List<OpeningHours>? openingHours;
  bool? activeOpeningHours;
  GreetingConfiguration? greetingConfiguration;
  bool? activeGreetingConfiguration;

  Bureaus(
      {required this.name,
      this.openingHours,
      this.activeOpeningHours,
      this.greetingConfiguration,
      this.activeGreetingConfiguration});

  factory Bureaus.init() {
    return Bureaus(
        name: "None",
        activeGreetingConfiguration: null,
        activeOpeningHours: null,
        greetingConfiguration: null,
        openingHours: null);
  }

  //Used for OpeningHours
  factory Bureaus.fromJsonOpeningHours(Map<String, dynamic> json) {
    List<OpeningHours> openingHoursList = [];
    if (json['openingHours'] != null) {
      var list = json['openingHours'] as List;
      print(list.runtimeType);
      openingHoursList = list.map((i) => OpeningHours.fromJson(i)).toList();
    }

    return Bureaus(
      name: json['name'],
      activeOpeningHours: json['activeOpeningHours'],
      openingHours: openingHoursList,
    );
  }

  //Used for OpeningHours
  Map<String, dynamic> toJsonOpeningHours() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['activeOpeningHours'] = this.activeOpeningHours;
    if (this.openingHours != null) {
      data['openingHours'] = this.openingHours?.map((v) => v.toJson()).toList();
    }
    data['greetingConfiguration'] = this.greetingConfiguration;
    return data;
  }

  //Used for Greeting
  factory Bureaus.fromJsonGreeting(Map<String, dynamic> json) {
    return Bureaus(
      name: json['name'],
      activeGreetingConfiguration: json['activeGreetingConfiguration'],
      greetingConfiguration:
          GreetingConfiguration.fromJson(json['greetingConfiguration']),
    );
  }

  //Used for Greeting
  Map<String, dynamic> toJsonGreeting() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['activeGreetingConfiguration'] = this.activeGreetingConfiguration;
    data['greetingConfiguration'] = this.greetingConfiguration?.toJson();
    return data;
  }
}

class OpeningHours {
  String weekday;
  String morningOpen;
  String morningClose;
  String afternoonOpen;
  String afternoonClose;

  OpeningHours(
      {required this.weekday,
      required this.morningOpen,
      required this.morningClose,
      required this.afternoonOpen,
      required this.afternoonClose});

  factory OpeningHours.init() {
    return OpeningHours(
        morningOpen: "08:00:00",
        morningClose: "12:00:00",
        afternoonOpen: "13:00:00",
        afternoonClose: "17:00:00",
        weekday: "none");
  }

  factory OpeningHours.fromJson(Map<String, dynamic> json) => new OpeningHours(
        weekday: json['weekday'],
        morningOpen: json['morningOpen'],
        morningClose: json['morningClose'],
        afternoonOpen: json['afternoonOpen'],
        afternoonClose: json['afternoonClose'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weekday'] = this.weekday;
    data['morningOpen'] = this.morningOpen;
    data['morningClose'] = this.morningClose;
    data['afternoonOpen'] = this.afternoonOpen;
    data['afternoonClose'] = this.afternoonClose;
    return data;
  }
}

class GreetingConfiguration {
  bool? organizationName;
  bool? firstName;
  bool? lastName;
  bool? bureau;
  bool? department;
  bool? salutation;
  List<String> specificWords = [];

  GreetingConfiguration({
    this.organizationName,
    this.firstName,
    this.lastName,
    this.bureau,
    this.department,
    this.salutation,
    required this.specificWords,
  });

  factory GreetingConfiguration.fromJson(Map<String, dynamic> json) =>
      new GreetingConfiguration(
        organizationName: json['organizationName'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        bureau: json['bureau'],
        department: json['department'],
        salutation: json['salutation'],
        specificWords: json["specificWords"] != null
            ? List<String>.from(json["specificWords"].map!((x) => x))
            : [],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['organizationName'] = this.organizationName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['bureau'] = this.bureau;
    data['department'] = this.department;
    data['salutation'] = this.salutation;
    data['specificWords'] =
        List<dynamic>.from(this.specificWords.map((x) => x));
    return data;
  }
}
