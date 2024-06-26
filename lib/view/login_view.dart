import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';
import 'package:login_riverpod_case_study/controller/auth_notifier.dart';
import 'package:login_riverpod_case_study/product/constants/color_constants.dart';
import 'package:login_riverpod_case_study/product/constants/string_constants.dart';
import 'package:login_riverpod_case_study/product/init/network_manager.dart';
import 'package:login_riverpod_case_study/service/login_service.dart';
import 'package:login_riverpod_case_study/view/home_view.dart';
import 'package:login_riverpod_case_study/product/mixin/navigate_mixin.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> with NavigateMixin {
  final GlobalKey<FormState> _key = GlobalKey();
  final ILoginService _loginService = LoginService(dio: NetworkManager.instance.service);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _obsureText = '*';
  final authenticationNotifier = StateNotifierProvider<AuthenticationNotifier, AuthenticationState>((ref) {
    return AuthenticationNotifier();
  });

  @override
  void initState() {
    super.initState();
    Future.microtask(() => isValidToken());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> isValidToken() async {
    await ref.watch(authenticationNotifier.notifier).isValidToken();
  }

  @override
  Widget build(BuildContext context) {
    final isRedirect = ref.watch(authenticationNotifier).isRedirect;
    final isLoading = ref.watch(authenticationNotifier).isLoading;
    return isRedirect == false
        ? const HomeView()
        : Scaffold(
            body: Center(
              child: Stack(
                children: [
                  Opacity(
                    opacity: isLoading ? 0.5 : 1,
                    child: IgnorePointer(
                      ignoring: isLoading,
                      child: Form(
                          key: _key,
                          autovalidateMode: AutovalidateMode.always,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: context.padding.low,
                                child: Text(
                                  StringConstants.appName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(color: ColorConstants.purpleDark),
                                ),
                              ),
                              Padding(
                                padding: context.padding.low,
                                child: _emailTextForm(),
                              ),
                              Padding(
                                padding: context.padding.low,
                                child: _passwordTextForm(),
                              ),
                              Padding(
                                padding: context.padding.low,
                                child: _loginButton(context),
                              ),
                            ],
                          )),
                    ),
                  ),
                  isLoading ? const Center(child: CircularProgressIndicator()) : const SizedBox.shrink(),
                ],
              ),
            ),
          );
  }

  TextFormField _passwordTextForm() {
    return TextFormField(
      controller: _passwordController,
      validator: (value) => value.ext.isValidPassword ? null : StringConstants.loginPasswordValidate,
      decoration: inputDecoration(labelText: StringConstants.loginPasswordLabel, password: true),
      obscureText: ref.watch(authenticationNotifier).isSecure,
      obscuringCharacter: _obsureText,
    );
  }

  ElevatedButton _loginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_key.currentState!.validate()) {
          ref.watch(authenticationNotifier.notifier).changeLoading();
          final response = await _loginService.postLogin(_emailController.text, _passwordController.text);
          if (response != null) {
            await ref.read(authenticationNotifier.notifier).tokenSaveToCache(response);
          }
          ref.watch(authenticationNotifier.notifier).changeLoading();

          if (!mounted) return;
          await navigateToWidgetReplacement(context, const HomeView());
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: context.border.lowBorderRadius,
        ),
        elevation: 0,
        backgroundColor: ColorConstants.purpleDark,
        disabledBackgroundColor: ColorConstants.purpleDark,
        maximumSize: const Size(double.infinity, 56),
        minimumSize: const Size(double.infinity, 56),
      ),
      child: const Text(
        StringConstants.loginButton,
        style: TextStyle(
          color: ColorConstants.white,
        ),
      ),
    );
  }

  TextFormField _emailTextForm() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => value.ext.isValidEmail ? null : StringConstants.loginEmailValidate,
      decoration: inputDecoration(labelText: StringConstants.loginEmailLabel),
    );
  }

  InputDecoration inputDecoration({required String labelText, bool password = false}) {
    return InputDecoration(
        border: OutlineInputBorder(
          borderRadius: context.border.lowBorderRadius,
        ),
        labelText: labelText,
        suffixIcon: password ? _onVisiblityIcon() : const SizedBox.shrink(),
        enabledBorder: _borderStyle(),
        disabledBorder: _borderStyle(),
        focusedBorder: _borderStyle());
  }

  OutlineInputBorder _borderStyle() {
    return const OutlineInputBorder(
      borderSide: BorderSide(
        color: ColorConstants.purpleDark,
        width: 2.0,
      ),
    );
  }

  IconButton _onVisiblityIcon() {
    return IconButton(
      onPressed: ref.watch(authenticationNotifier.notifier).changeSecure,
      icon: AnimatedCrossFade(
          firstChild: const Icon(Icons.visibility_outlined),
          secondChild: const Icon(Icons.visibility_off_outlined),
          crossFadeState:
              ref.watch(authenticationNotifier).isSecure ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(seconds: 1)),
    );
  }
}
