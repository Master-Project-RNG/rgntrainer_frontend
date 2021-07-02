class CallRange {
  int maxCalls;
  int minCalls;
  int minDaysBetweenCallsSingleNumber;
  int secondsBetweenCalls;
  int maxHoursForCallback;

  factory CallRange.init() {
    return CallRange(
      maxCalls: 0,
      minCalls: 0,
      minDaysBetweenCallsSingleNumber: 0,
      secondsBetweenCalls: 0,
      maxHoursForCallback: 0,
    );
  }

  CallRange({
    required this.maxCalls,
    required this.minCalls,
    required this.minDaysBetweenCallsSingleNumber,
    required this.secondsBetweenCalls,
    required this.maxHoursForCallback,
  });

  factory CallRange.fromJson(Map<String, dynamic> json) => CallRange(
        minCalls: json["minCalls"],
        maxCalls: json["maxCalls"],
        minDaysBetweenCallsSingleNumber:
            json["minDaysBetweenCallsSingleNumber"],
        maxHoursForCallback: json["maxHoursForCallback"],
        secondsBetweenCalls: json["secondsBetweenCalls"],
      );

  Map<String, dynamic> toJson(token) => {
        "token": token,
        "minCalls": minCalls,
        "maxCalls": maxCalls,
        "minDaysBetweenCallsSingleNumber": minDaysBetweenCallsSingleNumber,
        "maxHoursForCallback": maxHoursForCallback,
        "secondsBetweenCalls": secondsBetweenCalls,
      };
}
