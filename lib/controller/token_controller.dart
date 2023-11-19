// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_riverpod_case_study/product/init/shared_manager.dart';

class AuthenticationNotifier extends StateNotifier<AuthenticationState> {
  AuthenticationNotifier() : super(const AuthenticationState());

  Future<void> isValidToken() async {
    final SharedManager manager = SharedManager();
    await manager.init();

    state = state.copyWith(isRedirect: manager.getString(SharedKeys.token) != "");
  }

  Future<void> tokenSaveToCache(String token) async {
    final SharedManager manager = SharedManager();
    await manager.init();
    await manager.saveString(SharedKeys.token, token);
    state = state.copyWith(token: token, isRedirect: true);
    print(state.token);
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

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:login_riverpod_case_study/product/init/shared_manager.dart';

// class AuthenticationNotifier extends StateNotifier<AuthenticationState> {
//   AuthenticationNotifier() : super(AuthenticationState());

//   Future<void> isValidToken(SharedManager manager) async {
//     print("ddddddddddd");
//     print(manager.getString(SharedKeys.token));
//     // manager.getString(SharedKeys.token) == "" ? state.copyWith(isRedirect: false) : state.copyWith(isRedirect: true);
//   }

//   Future<void> tokenSaveToCache(String token) async {
//     final SharedManager manager = SharedManager();
//     await manager.init();
//     await manager.saveString(SharedKeys.token, token);

//     state.isRedirect = true;
//   }
// }

// class AuthenticationState {
//   AuthenticationState({this.token = "", this.isRedirect = false});

//   bool? isRedirect;
//   String? token;
// }
