// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  void changeLoading() {
    state = state.copyWith(isLoading: !(state.isLoading));
  }

  void changeSecure() {
    state = state.copyWith(isSecure: !(state.isSecure));
  }
}

class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.token = "",
    this.isRedirect = false,
    this.isLoading = false,
    this.isSecure = true,
  });

  final bool isRedirect;
  final String token;
  final bool isLoading;
  final bool isSecure;

  @override
  List<Object> get props => [isRedirect, token, isLoading, isSecure];

  AuthenticationState copyWith({
    bool? isRedirect,
    String? token,
    bool? isLoading,
    bool? isSecure,
  }) {
    return AuthenticationState(
      isRedirect: isRedirect ?? this.isRedirect,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      isSecure: isSecure ?? this.isSecure,
    );
  }
}
