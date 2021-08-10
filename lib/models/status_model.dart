class Status {
  DateTime startedAt;
  bool status;

  Status({
    required this.startedAt,
    required this.status,
  });

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
