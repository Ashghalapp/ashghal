// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  void onStatusChange(Function onConnect, Function onDisconect);
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker =
      InternetConnectionChecker();

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
  // Future<bool> get isConnected => Future.value(true);
  @override
  void onStatusChange(Function onConnect, Function onDisconect) {
    connectionChecker.onStatusChange.listen((event) async {
      if (await isConnected) {
        onConnect();
      } else {
        onDisconect();
      }
    });
  }
}
// class NetworkInfoImpl implements NetworkInfo {
//   @override
//   // Future<bool> get isConnected => Future.value(true);
//   Future<bool> get isConnected async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     return connectivityResult == ConnectivityResult.mobile ||
//         connectivityResult == ConnectivityResult.wifi;
//   }
// }
