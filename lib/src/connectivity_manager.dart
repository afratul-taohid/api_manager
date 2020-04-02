import 'package:connectivity/connectivity.dart';

/// Created by Taohid on 01, March, 2020
/// Internet connectivity check
class ConnectivityManager {
  static isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}
