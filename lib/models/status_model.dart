class Status {
  DateTime startedAt;
  bool status;

  Status({
    required this.startedAt,
    required this.status,
  });

  /// Factory method to create a dart object out of a json
  /// Icludes a formatting of the date so that it can be saved as DateTime
  factory Status.fromJson(Map<String, dynamic> json) => Status(
        startedAt: DateTime.parse(json["startedAt"].substring(6, 10) +
            "-" +
            json["startedAt"].substring(3, 5) +
            "-" +
            json["startedAt"].substring(0, 2) +
            " " +
            json["startedAt"].substring(11, 19)),
        status: json["status"],
      );

  factory Status.init() {
    return Status(status: false, startedAt: DateTime.now());
  }
}
