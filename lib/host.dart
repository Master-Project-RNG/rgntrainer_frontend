class Host {
  static const String localhost = "http://localhost:8080";
  static const String development = "http://rngtrainer-backend.herokuapp.com";
  static const String production = "http://188.155.65.59:8081";

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
