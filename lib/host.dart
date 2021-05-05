class Host {
  static const String localhost = "https://192.168.43.109:8080";
  static const String production = "https://188.155.65.59:8081";

  static final Host _host = Host._internal();

  factory Host() {
    return _host;
  }

  Host._internal();

  //set the active host!
  String getActiveHost() {
    return production; // <<<----------------------- Change backend here!
  }
}
