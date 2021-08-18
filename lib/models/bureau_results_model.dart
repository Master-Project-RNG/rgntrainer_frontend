// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'dart:ui';

List<BureauResults> bureauResultsFromJson(String str) =>
    List<BureauResults>.from(
        json.decode(str).map((x) => BureauResults.fromJson(x)));

String bureauResultsToJson(List<BureauResults> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.bureauResultstoJson2())));

class BureauResults {
  BureauResults({
    required this.bureau,
    required this.bureauStatistics,
    required this.abAndCallbackStatistics,
  });

  String bureau;
  BureauStatistics bureauStatistics;
  AbAndCallbackStatistics abAndCallbackStatistics;

  factory BureauResults.fromJson(Map<String, dynamic> json) => BureauResults(
        bureau: json["bureau"].toString(),
        bureauStatistics: BureauStatistics.fromJson(json['bureauStatistics']),
        abAndCallbackStatistics:
            AbAndCallbackStatistics.fromJson(json['abAndCallbackStatistics']),
      );

  Map<String, dynamic> bureauResultstoJson2() => {
        "bureau": bureau,
        "bureauStatistics": bureauStatistics,
        "abAndCallbackStatistics": abAndCallbackStatistics,
      };
}

class BureauStatistics {
  String totalCalls;
  String totalCallsReached;
  String rateSaidOrganization;
  String rateSaidBureau;
  String rateSaidDepartment;
  String rateSaidFirstname;
  String rateSaidName;
  String rateSaidGreeting;
  String rateSaidSpecificWords;
  String rateReached;
  String rateCallCompleted;
  String meanRingingTime;

  BureauStatistics({
    required this.totalCalls,
    required this.totalCallsReached,
    required this.rateSaidOrganization,
    required this.rateSaidBureau,
    required this.rateSaidDepartment,
    required this.rateSaidFirstname,
    required this.rateSaidName,
    required this.rateSaidGreeting,
    required this.rateSaidSpecificWords,
    required this.rateReached,
    required this.rateCallCompleted,
    required this.meanRingingTime,
  });

  factory BureauStatistics.fromJson(Map<String, dynamic> json) =>
      BureauStatistics(
        totalCalls: json["totalCalls"].toString(),
        totalCallsReached: json["totalCallsReached"].toString(),
        rateSaidOrganization: json["rateSaidOrganization"].toString(),
        rateSaidBureau: json["rateSaidBureau"].toString(),
        rateSaidDepartment: json["rateSaidDepartment"].toString(),
        rateSaidFirstname: json["rateSaidFirstname"].toString(),
        rateSaidName: json["rateSaidName"].toString(),
        rateSaidGreeting: json["rateSaidGreeting"].toString(),
        rateSaidSpecificWords: json["rateSaidSpecificWords"].toString(),
        rateReached: json["rateReached"].toString(),
        rateCallCompleted: json["rateCallCompleted"].toString(),
        meanRingingTime: json["meanRingingTime"].toString(),
      );

  Map<String, dynamic> bureauStatisticstoJson() => {
        "totalCalls": totalCalls,
        "totalCallsReached": totalCallsReached,
        "rateSaidOrganization": rateSaidOrganization,
        "rateSaidBureau": rateSaidBureau,
        "rateSaidDepartment": rateSaidDepartment,
        "rateSaidFirstname": rateSaidFirstname,
        "rateSaidName": rateSaidName,
        "rateSaidGreeting": rateSaidGreeting,
        "rateSaidSpecificWords": rateSaidSpecificWords,
        "rateReached": rateReached,
        "rateCallCompleted": rateCallCompleted,
        "meanRingingTime": meanRingingTime,
      };

  ///Used in diagrams
  static Map<String, Color> bureauStatisticsDiagramColors = {
    "totalCalls": const Color(0xff4af699),
    "totalCallsReached": const Color(0xfff542a4),
    "rateSaidOrganization": const Color(0xfffad51b),
    "rateSaidBureau": const Color(0xffff0000),
    "rateSaidDepartment": const Color(0xff8c12ff),
    "rateSaidFirstname": const Color(0xffffff1c),
    "rateSaidName": const Color(0xffff29f1),
    "rateSaidGreeting": const Color(0xff009c41),
    "rateSaidSpecificWords": const Color(0xffffb300),
    "rateReached": const Color(0xff1c95ff),
    "rateCallCompleted": const Color(0xff42e9f5)
  };

  ///Provides translation from English to German
  static Map<String, String> bureauStatisticsTranslationToGerman = {
    "totalCalls": "Totale Anrufe",
    "totalCallsReached": "Anrufe beantwortet",
    "rateSaidOrganization": "Organisation gesagt",
    "rateSaidBureau": "Büro gesagt",
    "rateSaidDepartment": "Abteilung gesagt",
    "rateSaidFirstname": "Vorname gesagt",
    "rateSaidName": "Nachname gesagt",
    "rateSaidGreeting": "Begrüssung gesagt",
    "rateSaidSpecificWords": "Spezifische Wörter gesagt",
    "rateReached": "Erreicht",
    "rateCallCompleted": "Anruf komplett"
  };
}

class AbAndCallbackStatistics {
  String rateSaidOrganizationAB;
  String rateSaidBureauAB;
  String rateSaidDepartmentAB;
  String rateSaidFirstnameAB;
  String rateSaidNameAB;
  String rateSaidGreetingAB;
  String rateSaidSpecificWordsAB;
  String rateResponderStartedIfNotReached;
  String rateResponderCorrect;
  String rateCallbackDoneNoAnswer;
  String rateCallbackDoneResponder;
  String rateCallbackDoneUnexpected;
  String rateCallbackDoneOverall;
  String rateCallbackInTime;

  AbAndCallbackStatistics({
    required this.rateSaidOrganizationAB,
    required this.rateSaidBureauAB,
    required this.rateSaidDepartmentAB,
    required this.rateSaidFirstnameAB,
    required this.rateSaidNameAB,
    required this.rateSaidGreetingAB,
    required this.rateSaidSpecificWordsAB,
    required this.rateResponderStartedIfNotReached,
    required this.rateResponderCorrect,
    required this.rateCallbackDoneNoAnswer,
    required this.rateCallbackDoneResponder,
    required this.rateCallbackDoneUnexpected,
    required this.rateCallbackDoneOverall,
    required this.rateCallbackInTime,
  });

  factory AbAndCallbackStatistics.fromJson(Map<String, dynamic> json) =>
      AbAndCallbackStatistics(
        rateSaidOrganizationAB: json["rateSaidOrganizationAB"].toString(),
        rateSaidBureauAB: json["rateSaidBureauAB"].toString(),
        rateSaidDepartmentAB: json["rateSaidDepartmentAB"].toString(),
        rateSaidFirstnameAB: json["rateSaidFirstnameAB"].toString(),
        rateSaidNameAB: json["rateSaidNameAB"].toString(),
        rateSaidGreetingAB: json["rateSaidGreetingAB"].toString(),
        rateSaidSpecificWordsAB: json["rateSaidSpecificWordsAB"].toString(),
        rateResponderStartedIfNotReached:
            json["rateResponderStartedIfNotReached"].toString(),
        rateResponderCorrect: json["rateResponderCorrect"].toString(),
        rateCallbackDoneNoAnswer: json["rateCallbackDoneNoAnswer"].toString(),
        rateCallbackDoneResponder: json["rateCallbackDoneResponder"].toString(),
        rateCallbackDoneUnexpected:
            json["rateCallbackDoneUnexpected"].toString(),
        rateCallbackDoneOverall: json["rateCallbackDoneOverall"].toString(),
        rateCallbackInTime: json["rateCallbackInTime"].toString(),
      );

  Map<String, dynamic> abAndCallbackStatisticstoJson() => {
        "rateSaidOrganizationAB": rateSaidOrganizationAB,
        "rateSaidBureauAB": rateSaidBureauAB,
        "rateSaidDepartmentAB": rateSaidDepartmentAB,
        "rateSaidFirstnameAB": rateSaidFirstnameAB,
        "rateSaidNameAB": rateSaidNameAB,
        "rateSaidGreetingAB": rateSaidGreetingAB,
        "rateSaidSpecificWordsAB": rateSaidSpecificWordsAB,
        "rateResponderStartedIfNotReached": rateResponderStartedIfNotReached,
        "rateResponderCorrect": rateResponderCorrect,
        "rateCallbackDoneNoAnswer": rateCallbackDoneNoAnswer,
        "rateCallbackDoneResponder": rateCallbackDoneResponder,
        "rateCallbackDoneUnexpected": rateCallbackDoneUnexpected,
        "rateCallbackDoneOverall": rateCallbackDoneOverall,
        "rateCallbackInTime": rateCallbackInTime,
      };
}
