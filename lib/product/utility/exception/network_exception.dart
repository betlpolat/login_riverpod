class NetworkException implements Exception {
  final String statusCode;
  final String message;

  NetworkException(this.statusCode, this.message);
}
