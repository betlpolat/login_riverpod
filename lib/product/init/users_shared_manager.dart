import 'dart:convert';

import 'package:login_riverpod_case_study/model/users.dart';
import 'package:login_riverpod_case_study/product/init/shared_manager.dart';

class UsersSharedManager {
  final SharedManager sharedManager;

  UsersSharedManager(this.sharedManager);

  Future<void> saveItems(List<Data> items) async {
    final items0 = items.map((element) => jsonEncode(element.toJson())).toList();
    await sharedManager.saveStringItems(SharedKeys.users, items0);
  }

  List<Data>? getItems() {
    final itemsString = sharedManager.getStrings(SharedKeys.users);
    if (itemsString?.isNotEmpty ?? false) {
      return itemsString!.map((element) {
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
