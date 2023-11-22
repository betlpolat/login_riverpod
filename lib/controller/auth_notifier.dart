import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_riverpod_case_study/product/init/cache/cache_keys.dart';

class AuthenticationNotifier extends StateNotifier<AuthenticationState> {
  AuthenticationNotifier() : super(const AuthenticationState());

  Future<void> isValidToken() async {
    state = state.copyWith(isRedirect: CacheKeys.token.readString != "");
  }

  Future<void> tokenSaveToCache(String token) async {
    await CacheKeys.token.writeString(token);
    state = state.copyWith(token: token, isRedirect: true);
  }
}

class AuthenticationState extends Equatable {
  const AuthenticationState({this.token = "", this.isRedirect = false});

  final bool isRedirect;
  final String token;

  @override
  List<Object?> get props => [token, isRedirect];

  AuthenticationState copyWith({
    bool? isRedirect,
    String? token,
  }) {
    return AuthenticationState(
      isRedirect: isRedirect ?? this.isRedirect,
      token: token ?? this.token,
    );
  }
}
