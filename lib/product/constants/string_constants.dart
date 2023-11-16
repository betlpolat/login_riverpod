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
  // static const loginWelcomeBack = 'Welcome Back 👋';
  // static const loginWelcomeDetail = 'I am happy to see you again. You can continue where you left off by logging in';

  // static const continueToApp = 'Continue to app';

  // // Home
  // static const homeBrowse = 'Browse';
  // static const homeMessage = 'I am happy to see you again. You can continue where you left off by logging in';

  // static const homeTitle = 'Recommended for you';
  // static const homeSeeAll = 'See all';
  // static const homeSearchHint = 'Search';
  // static const addItemTitle = 'Add new item';

  // // Component
  // static const String dropdownHint = 'Select Items';
  // static const String dropdownTitle = 'Title';
  // static const String buttonSave = 'Save';
}
