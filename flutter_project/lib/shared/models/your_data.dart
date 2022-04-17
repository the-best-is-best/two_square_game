class YourData {
  static int score = 0;
  static int winHard4 = 0;
  static int winHard3 = 0;
  static int winMedium3 = 0;

  static Map toMap() {
    return {
      "score": score,
      "winHard4": winHard4,
      "winHard3": winHard3,
      "winMedium3": winMedium3
    };
  }
}
