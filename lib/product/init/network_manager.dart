import 'package:dio/dio.dart';
import 'package:login_riverpod_case_study/product/constants/string_constants.dart';

class NetworkManager {
  NetworkManager._() {
    _dio = Dio(BaseOptions(
      baseUrl: StringConstants.basePath,
      headers: {
        "Content-Type": "application/json",
      },
    ));
  }

  late final Dio _dio;

  static NetworkManager instance = NetworkManager._();
  Dio get service => _dio;
}
