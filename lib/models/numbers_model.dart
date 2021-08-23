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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Number &&
          runtimeType == other.runtimeType &&
          basepool_id == other.basepool_id &&
          user_id == other.user_id &&
          number == other.number &&
          firstname == other.firstname &&
          lastname == other.lastname &&
          bureau == other.bureau &&
          department == other.department &&
          email == other.email;

  Number copy({
    String? basepool_id,
    String? user_id,
    String? number,
    String? firstname,
    String? lastname,
    String? bureau,
    String? department,
    String? email,
  }) =>
      Number(
        basepool_id: basepool_id ?? this.basepool_id,
        user_id: user_id ?? this.user_id,
        number: number ?? this.number,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        bureau: bureau ?? this.bureau,
        department: department ?? this.department,
        email: email ?? this.email,
      );

  @override
  int get hashCode =>
      basepool_id.hashCode ^
      user_id.hashCode ^
      number.hashCode ^
      firstname.hashCode ^
      lastname.hashCode ^
      bureau.hashCode ^
      department.hashCode ^
      email.hashCode;
}
