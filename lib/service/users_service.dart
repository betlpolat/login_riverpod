import 'dart:io';
import 'package:dio/dio.dart';
import 'package:login_riverpod_case_study/model/users_model.dart';
import 'package:login_riverpod_case_study/product/constants/string_constants.dart';

abstract class IUsersService {
  final Dio dio;
  Future<List<Data>?> getUsers();
  IUsersService({required this.dio});
}

class UsersService extends IUsersService {
  UsersService({required super.dio});

  @override
  Future<List<Data>?> getUsers() async {
    late final Response response;
    try {
      response = await dio.get(
        StringConstants.usersPath,
      );

      if (response.statusCode == HttpStatus.ok) {
        final jsonBody = response.data;
        if (jsonBody is Map<String, dynamic>) {
          final response = UsersModel.fromJson(jsonBody).data;
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
