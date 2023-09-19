// class OfflineException implements Exception {
//   final dynamic message;

//   OfflineException([this.message]);
// }

// class ServerException implements Exception {}

// class EmptyCacheException implements Exception {}

class AppException implements Exception {
  final dynamic failure;

  AppException(this.failure);
}
