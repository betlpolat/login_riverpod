import 'dart:io';
import 'package:dio/dio.dart';
import 'package:login_riverpod_case_study/model/login_model.dart';
import 'package:login_riverpod_case_study/model/token_model.dart';
import 'package:login_riverpod_case_study/product/constants/string_constants.dart';

abstract class ILoginService {
  final Dio dio;
  Future<String?> postLogin(String email, String password);
  ILoginService({required this.dio});
}

class LoginService extends ILoginService {
  LoginService({required super.dio});

  @override
  Future<String?> postLogin(String email, String password) async {
    final model = LoginModel(email: email, password: password);
    late final Response response;
    try {
      response = await dio.post(
        StringConstants.loginPath,
        data: model,
      );

      if (response.statusCode == HttpStatus.ok) {
        final jsonBody = response.data;
        if (jsonBody is Map<String, dynamic>) {
          final response = TokenModel.fromJson(jsonBody).token;
          return response;
        }
      }
    } catch (e) {
      throw NetworkError(
        response.statusCode.toString(),
        response.data,
      );
    }
    return null;
  }
}

class NetworkError implements Exception {
  final String statusCode;
  final String message;

  NetworkError(this.statusCode, this.message);
}
