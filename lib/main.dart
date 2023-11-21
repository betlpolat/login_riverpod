import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_riverpod_case_study/product/constants/string_constants.dart';
import 'package:login_riverpod_case_study/product/init/application_start.dart';
import 'package:login_riverpod_case_study/view/login_view.dart';

void main() async {
  await ApplicationStart.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: StringConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(appBarTheme: const AppBarTheme(centerTitle: true)),
      home: const LoginView(),
    );
  }
}
