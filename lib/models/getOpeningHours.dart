import 'package:rgntrainer_frontend/models/user.dart';

class OpeningHoursSummary {
  String name;
  List<Bureaus>? bureaus;
  List<User> users;
  List<OpeningHours> openingHours;
  String? greetingConfiguration;

  factory OpeningHoursSummary.init() {
    return OpeningHoursSummary(
        name: "None",
        bureaus: [],
        users: [User.init()],
        openingHours: [
          OpeningHours.init(),
          OpeningHours.init(),
          OpeningHours.init(),
          OpeningHours.init(),
          OpeningHours.init()
        ],
        greetingConfiguration: "none");
  }

  OpeningHoursSummary(
      {required this.name,
      required this.bureaus,
      required this.users,
      required this.openingHours,
      this.greetingConfiguration});

  factory OpeningHoursSummary.fromJson(Map<String, dynamic> json) {
    List<Bureaus> bureausList = [];
    if (json['bureaus'] != null) {
      var list = json['bureaus'] as List;
      print(list.runtimeType);
      bureausList = list.map((i) => Bureaus.fromJson(i)).toList();
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

    return OpeningHoursSummary(
      name: json['name'],
      bureaus: bureausList,
      users: usersList,
      openingHours: openingHoursList,
      greetingConfiguration: json['greetingConfiguration'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.bureaus != null) {
      data['bureaus'] = this.bureaus?.map((v) => v.toJson()).toList();
    }
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    if (this.openingHours != null) {
      data['openingHours'] = this.openingHours.map((v) => v.toJson()).toList();
    }
    data['greetingConfiguration'] = this.greetingConfiguration;
    return data;
  }
}

class Bureaus {
  String name;
  List<OpeningHours>? openingHours;
  String? greetingConfiguration;

  Bureaus(
      {required this.name,
      required this.openingHours,
      required this.greetingConfiguration});

  factory Bureaus.fromJson(Map<String, dynamic> json) {
    List<OpeningHours> openingHoursList = [];
    if (json['openingHours'] != null) {
      var list = json['openingHours'] as List;
      print(list.runtimeType);
      openingHoursList = list.map((i) => OpeningHours.fromJson(i)).toList();
    }

    return Bureaus(
      name: json['name'],
      openingHours: openingHoursList,
      greetingConfiguration: json['greetingConfiguration'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.openingHours != null) {
      data['openingHours'] = this.openingHours?.map((v) => v.toJson()).toList();
    }
    data['greetingConfiguration'] = this.greetingConfiguration;
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
