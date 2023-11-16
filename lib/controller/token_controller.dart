import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_riverpod_case_study/product/init/shared_manager.dart';

class AuthenticationNotifier extends StateNotifier<AuthenticationState> {
  AuthenticationNotifier() : super(const AuthenticationState());

  Future<void> isValidToken(SharedManager manager) async {
    manager.getString(SharedKeys.token) == "" ? state.copyWith(isRedirect: false) : state.copyWith(isRedirect: true);
  }

  Future<void> tokenSaveToCache(String token) async {
    final SharedManager manager = SharedManager();
    await manager.init();
    await manager.saveString(SharedKeys.token, token);
    state.copyWith(token: token, isRedirect: true);
  }
}

class AuthenticationState extends Equatable {
  const AuthenticationState({this.token = "", this.isRedirect = false});

  final bool isRedirect;
  final String token;

  @override
  List<Object> get props => [isRedirect, token];

  AuthenticationState copyWith({bool? isRedirect, String? token}) {
    return AuthenticationState(
      isRedirect: isRedirect ?? this.isRedirect,
    );
  }
}