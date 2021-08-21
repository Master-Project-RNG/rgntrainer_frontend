class Number {
  String basepool_id;
  String user_id;
  String number;
  String firstname;
  String lastname;
  String bureau;
  String department;
  String email;

  Number({
    required this.basepool_id,
    required this.user_id,
    required this.number,
    required this.firstname,
    required this.lastname,
    required this.bureau,
    required this.department,
    required this.email,
  });

  factory Number.fromJson(Map<String, dynamic> json) => Number(
        basepool_id: json["basepool_id"],
        user_id: json["user_id"],
        number: json["number"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        bureau: json["bureau"],
        department: json["department"],
        email: json["email"],
      );
}
