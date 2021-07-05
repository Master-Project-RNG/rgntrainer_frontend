// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<BureauResults> bureauResultsFromJson(String str) =>
    List<BureauResults>.from(
        json.decode(str).map((x) => BureauResults.fromJson(x)));

String bureauResultsToJson(List<BureauResults> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.bureauResultstoJson())));

class BureauResults {
  BureauResults({
    required this.bureau,
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
    required this.rateResponderStartedIfNotReached,
    required this.rateResponderCorrect,
    required this.rateCallbackDone,
    required this.rateCallbackInTime,
    required this.meanRingingTime,
  });

  String bureau;
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
  String rateResponderStartedIfNotReached;
  String rateResponderCorrect;
  String rateCallbackDone;
  String rateCallbackInTime;
  String meanRingingTime;

  factory BureauResults.fromJson(Map<String, dynamic> json) => BureauResults(
        bureau: json["bureau"].toString(),
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
        rateResponderStartedIfNotReached:
            json["rateResponderStartedIfNotReached"].toString(),
        rateResponderCorrect: json["rateResponderCorrect"].toString(),
        rateCallbackDone: json["rateCallbackDone"].toString(),
        rateCallbackInTime: json["rateCallbackInTime"].toString(),
        meanRingingTime: json["meanRingingTime"].toString(),
      );

  Map<String, dynamic> bureauResultstoJson() => {
        "bureau": bureau,
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
        "rateResponderStartedIfNotReached": rateResponderStartedIfNotReached,
        "rateResponderCorrect": rateResponderCorrect,
        "rateCallbackDone": rateCallbackDone,
        "rateCallbackInTime": rateCallbackInTime,
        "meanRingingTime": meanRingingTime,
      };
}
