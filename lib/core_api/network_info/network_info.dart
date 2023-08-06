import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

// class NetworkInfoImpl implements NetworkInfo {
//   final InternetConnectionChecker connectionChecker =
//       InternetConnectionChecker();

//   @override
//   // Future<bool> get isConnected => connectionChecker.hasConnection;
//   Future<bool> get isConnected => Future.value(true);
// }
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected => Future.value(true);
  // Future<bool> get isConnected async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   return connectivityResult == ConnectivityResult.mobile ||
  //       connectivityResult == ConnectivityResult.wifi;
  // }
}
