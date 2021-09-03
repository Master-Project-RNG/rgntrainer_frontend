class UserResults {
  final String? bureau;
  final bool? callCompleted;
  final bool? callbackDone;
  final bool? callbackInTime;
  final String? date;
  final String? department;
  final String? number;
  final bool? reached;
  final bool? responderCorrect;
  final bool? responderStarted;
  final bool? saidBureau;
  final bool? saidDepartment;
  final bool? saidFirstname;
  final bool? saidGreeting;
  final bool? saidName;
  final bool? saidOrganization;
  final bool? saidSpecificWords;

  UserResults({
    required this.bureau,
    required this.callCompleted,
    required this.callbackDone,
    required this.callbackInTime,
    required this.date,
    required this.department,
    required this.number,
    required this.reached,
    required this.responderCorrect,
    required this.responderStarted,
    required this.saidBureau,
    required this.saidDepartment,
    required this.saidFirstname,
    required this.saidGreeting,
    required this.saidName,
    required this.saidOrganization,
    required this.saidSpecificWords,
  });

  /// Factory method to create a dart object out of a json
  factory UserResults.fromJson(Map<String, dynamic> json) {
    return UserResults(
      bureau: json['bureau'],
      callCompleted: json['callCompleted'],
      callbackDone: json['callbackDone'],
      callbackInTime: json['callbackInTime'],
      date: json['date'],
      department: json['department'],
      number: json['number'],
      reached: json['reached'],
      responderCorrect: json['responderCorrect'],
      responderStarted: json['responderStarted'],
      saidBureau: json['saidBureau'],
      saidDepartment: json['saidDepartment'],
      saidFirstname: json['saidFirstname'],
      saidGreeting: json['saidGreeting'],
      saidName: json['saidName'],
      saidOrganization: json['saidOrganization'],
      saidSpecificWords: json['saidSpecificWords'],
    );
  }
}
