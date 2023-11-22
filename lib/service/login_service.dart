import 'dart:io';
import 'package:dio/dio.dart';
import 'package:login_riverpod_case_study/model/login.dart';
import 'package:login_riverpod_case_study/model/token.dart';
import 'package:login_riverpod_case_study/product/constants/string_constants.dart';
import 'package:login_riverpod_case_study/product/utility/exception/network_exception.dart';

abstract class ILoginService {
  final Dio dio;
  Future<String?> postLogin(String email, String password);
  ILoginService({required this.dio});
}

class LoginService extends ILoginService {
  LoginService({required super.dio});

  @override
  Future<String?> postLogin(String email, String password) async {
    final model = Login(email: email, password: password);
    late final Response response;
    try {
      response = await dio.post(
        StringConstants.loginPath,
        data: model,
      );

      if (response.statusCode == HttpStatus.ok) {
        final jsonBody = response.data;
        if (jsonBody is Map<String, dynamic>) {
          final response = Token.fromJson(jsonBody).token;
          return response;
        }
      }
    } catch (e) {
      throw NetworkException(
        response.statusCode.toString(),
        response.data,
      );
    }
    return null;
  }
}
