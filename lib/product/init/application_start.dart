import 'package:flutter/material.dart';
import 'package:login_riverpod_case_study/product/init/cache/app_cache.dart';

@immutable
class ApplicationStart {
  const ApplicationStart._();
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await AppCache.instance.setUp();
  }
}
