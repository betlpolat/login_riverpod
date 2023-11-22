import 'dart:convert';

import 'package:login_riverpod_case_study/model/users.dart';
import 'package:login_riverpod_case_study/product/init/cache/app_cache.dart';

enum CacheKeys {
  token,
  users;

  String get readString => AppCache.instance.sharedPreferences.getString(name) ?? '';
  Future<bool> writeString(String value) => AppCache.instance.sharedPreferences.setString(name, value);

  Future<void> writeListString(List<Data> items) async {
    final items0 = items.map((element) => jsonEncode(element.toJson())).toList();
    await AppCache.instance.sharedPreferences.setStringList(name, items0);
  }

  List<Data>? readListString() {
    final itemsString = AppCache.instance.sharedPreferences.getStringList(name) ?? [];
    if (itemsString.isNotEmpty) {
      return itemsString.map((element) {
        final json = jsonDecode(element);
        if (json is Map<String, dynamic>) {
          return Data.fromJson(json);
        }
        return Data();
      }).toList();
    }
    return null;
  }
}
