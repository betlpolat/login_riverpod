import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';
import 'package:login_riverpod_case_study/controller/token_controller.dart';
import 'package:login_riverpod_case_study/product/constants/color_constants.dart';
import 'package:login_riverpod_case_study/product/constants/string_constants.dart';
import 'package:login_riverpod_case_study/product/init/network_manager.dart';
import 'package:login_riverpod_case_study/product/init/shared_manager.dart';
import 'package:login_riverpod_case_study/product/mixin/navigate_mixin.dart';
import 'package:login_riverpod_case_study/service/login_service.dart';
import 'package:login_riverpod_case_study/view/home_view.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> with NavigateMixin {
  final authProvider = StateNotifierProvider<AuthenticationNotifier, AuthenticationState>((ref) {
    return AuthenticationNotifier();
  });

  final GlobalKey<FormState> _key = GlobalKey();
  final ILoginService _loginService = LoginService(dio: NetworkManager.instance.service);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final _obsureText = '*';
  bool _isSecure = true;
  bool _isDirect = false;

  late final SharedManager _manager;

  @override
  void initState() {
    startShared();
    super.initState();
  }

  Future<void> startShared() async {
    _manager = SharedManager();
    await _manager.init();
    ref.read(authProvider.notifier).isValidToken(_manager);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      _isDirect = next.isRedirect;
    });
    return _isDirect
        ? const HomeView()
        : Scaffold(
            body: Center(
              child: Stack(
                children: [
                  Opacity(
                    opacity: _isLoading ? 0.5 : 1,
                    child: IgnorePointer(
                      ignoring: _isLoading,
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
                  _isLoading ? const Center(child: CircularProgressIndicator()) : const SizedBox.shrink(),
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
      obscureText: _isSecure,
      obscuringCharacter: _obsureText,
    );
  }

  ElevatedButton _loginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_key.currentState!.validate()) {
          changeLoading();
          final response = await _loginService.postLogin(_emailController.text, _passwordController.text);
          if (response != null) {
            await ref.read(authProvider.notifier).tokenSaveToCache(response);
          }

          if (!mounted) return;
          changeLoading();
          response != null ? navigateToWidgetReplacement(context, const HomeView()) : const SizedBox.shrink();
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
        suffixIcon: password ? onVisiblityIcon() : const SizedBox.shrink(),
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

  void changeLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void changeSecure() {
    setState(() {
      _isSecure = !_isSecure;
    });
  }

  IconButton onVisiblityIcon() {
    return IconButton(
      onPressed: changeSecure,
      icon: AnimatedCrossFade(
          firstChild: const Icon(Icons.visibility_outlined),
          secondChild: const Icon(Icons.visibility_off_outlined),
          crossFadeState: _isSecure ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(seconds: 1)),
    );
  }
}