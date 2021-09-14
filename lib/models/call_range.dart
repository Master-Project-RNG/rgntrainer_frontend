class CallRange {
  int maxCalls;
  int minCalls;
  int maxHoursForCallback;
  int minDaysBetweenCallsSingleNumber;
  int secondsBetweenCalls;

  CallRange({
    required this.maxCalls,
    required this.maxHoursForCallback,
    required this.minCalls,
    required this.minDaysBetweenCallsSingleNumber,
    required this.secondsBetweenCalls,
  });

  factory CallRange.init() {
    return CallRange(
      maxCalls: 0,
      minCalls: 0,
      minDaysBetweenCallsSingleNumber: 0,
      secondsBetweenCalls: 0,
      maxHoursForCallback: 0,
    );
  }

  /// Factory method to create a dart object out of a json
  factory CallRange.fromJson(Map<String, dynamic> json) => CallRange(
        minCalls: json["minCalls"] as int,
        maxCalls: json["maxCalls"] as int,
        minDaysBetweenCallsSingleNumber:
            json["minDaysBetweenCallsSingleNumber"] as int,
        maxHoursForCallback: json["maxHoursForCallback"] as int,
        secondsBetweenCalls: json["secondsBetweenCalls"] as int,
      );

  /// Factory method to create json out of a dart object
  Map<String, dynamic> toJson(String token) => {
        "token": token,
        "minCalls": minCalls,
        "maxCalls": maxCalls,
        "minDaysBetweenCallsSingleNumber": minDaysBetweenCallsSingleNumber,
        "maxHoursForCallback": maxHoursForCallback,
        "secondsBetweenCalls": secondsBetweenCalls,
      };
}
