import 'package:simple_connection_checker/simple_connection_checker.dart';

class CheckInternet {
  static bool isConnected = false;

  static Future init() async {
    isConnected = await SimpleConnectionChecker.isConnectedToInternet();
  }
}
