import 'dart:io';
import 'package:dio/dio.dart';
import 'package:login_riverpod_case_study/model/users.dart';
import 'package:login_riverpod_case_study/product/constants/string_constants.dart';
import 'package:login_riverpod_case_study/product/utility/exception/network_exception.dart';

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
          final response = Users.fromJson(jsonBody).data;
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
