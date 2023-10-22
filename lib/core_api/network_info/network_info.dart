// import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

import 'package:ashghal_app_frontend/core/services/app_services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  // void onStatusChange({
  //   required void Function() onConnect,
  //   required void Function() onDisconect,
  // });
}

/// NetworkInfoImpl is a class that provides network-related information and events.
///
/// It uses the InternetConnectionChecker library to determine the device's
/// internet connectivity status and provides a stream to listen for changes
/// in the connection status.
class NetworkInfoImpl implements NetworkInfo {
  /// The InternetConnectionChecker instance used to check connectivity.
  final InternetConnectionChecker _connectionChecker =
      InternetConnectionChecker();

  /// A private static instance of the NetworkInfoImpl class.
  static NetworkInfoImpl? _instance;

  /// Private constructor for NetworkInfoImpl.
  ///
  /// The constructor initializes the onStatusChange method.
  NetworkInfoImpl._() {
    _onStatusChange();
  }

  /// Factory constructor for NetworkInfoImpl.
  ///
  /// Returns the existing instance of NetworkInfoImpl if it exists,
  /// or creates a new instance if one doesn't exist.
  factory NetworkInfoImpl() {
    _instance ??= NetworkInfoImpl._();
    return _instance!;
  }

  @override
  Future<bool> get isConnected => _connectionChecker.hasConnection;

  /// A StreamController to manage the stream of network status changes.
  final StreamController<bool> _statusController =
      StreamController<bool>.broadcast();

  /// A stream to listen for internet connection status changes.
  ///
  /// Returns:
  ///
  /// - `true` on internet connection.
  ///
  /// - `false` on internet disconnection.
  Stream<bool> get onStatusChanged => _statusController.stream;

  // ...

  /// Listens for internet connection status changes and notifies the stream.
  void _onStatusChange() async {
    _connectionChecker.onStatusChange.listen((event) async {
      if (event == InternetConnectionStatus.connected) {
        _statusController.add(true); // Notify connected
      } else {
        _statusController.add(false); // Notify disconnected
      }
    });
  }

  /// Closes the stream controller when it is no longer needed.
  void dispose() {
    _statusController.close();
  }
}
