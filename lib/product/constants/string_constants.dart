import 'package:flutter/material.dart';

@immutable
class StringConstants {
  const StringConstants._();
  static const String appName = 'Login Riverpod';

  //Network
  static const String basePath = 'https://reqres.in/api/';
  static const String loginPath = 'login';
  static const String usersPath = "users";

  // Login
  static const loginEmailLabel = 'E-mail';
  static const loginPasswordLabel = 'Şifre';
  static const loginButton = "Giriş Yap";
  static const loginEmailValidate = 'Geçerli bir email adresi giriniz.';
  static const loginPasswordValidate =
      'Şifre en az 8 karakter uzunluğunda olmalıdır ve bir büyük-küçük harf,sayı ve özel karakter içermelidir.';

  //Home
  static const homeTitle = "Kullanıcılar";
}
