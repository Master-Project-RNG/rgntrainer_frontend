class Validator {
  static validateTime(value) {
    {
      if (value.toString().length != 5) {
        return 'Ungültig!';
      }
      if ((value.toString().substring(0, 1) != "0") &&
          (value.toString().substring(0, 1) != "1") &&
          (value.toString().substring(0, 1) != "2")) {
        return 'Ungültig!';
      }
      //Falls die erste Zahl == 2 ist, dann darf die zweite nicht höher als 3 sein.
      if ((value.toString().substring(0, 1) == "2") &&
          (value.toString().substring(1, 2) != "0") &&
          (value.toString().substring(1, 2) != "1") &&
          (value.toString().substring(1, 2) != "2") &&
          (value.toString().substring(1, 2) != "3")) {
        return 'Ungültig!';
      }
      if ((value.toString().substring(1, 2) != "0") &&
          (value.toString().substring(1, 2) != "1") &&
          (value.toString().substring(1, 2) != "2") &&
          (value.toString().substring(1, 2) != "3") &&
          (value.toString().substring(1, 2) != "4") &&
          (value.toString().substring(1, 2) != "5") &&
          (value.toString().substring(1, 2) != "6") &&
          (value.toString().substring(1, 2) != "7") &&
          (value.toString().substring(1, 2) != "8") &&
          (value.toString().substring(1, 2) != "9")) {
        return 'Ungültig!';
      }
      if (value.toString().substring(2, 3) != ":") {
        return 'Ungültig!';
      }
      if ((value.toString().substring(3, 4) != "0") &&
          (value.toString().substring(3, 4) != "1") &&
          (value.toString().substring(3, 4) != "2") &&
          (value.toString().substring(3, 4) != "3") &&
          (value.toString().substring(3, 4) != "4") &&
          (value.toString().substring(3, 4) != "5")) {
        return 'Ungültig!';
      }
      if ((value.toString().substring(4, 5) != "0") &&
          (value.toString().substring(4, 5) != "1") &&
          (value.toString().substring(4, 5) != "2") &&
          (value.toString().substring(4, 5) != "3") &&
          (value.toString().substring(4, 5) != "4") &&
          (value.toString().substring(4, 5) != "5") &&
          (value.toString().substring(4, 5) != "6") &&
          (value.toString().substring(4, 5) != "7") &&
          (value.toString().substring(4, 5) != "8") &&
          (value.toString().substring(4, 5) != "9")) {
        return 'Ungültig!';
      }
    }
  }
}
