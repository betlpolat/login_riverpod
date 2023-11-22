import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';
import 'package:login_riverpod_case_study/model/users_model.dart';
import 'package:login_riverpod_case_study/product/constants/color_constants.dart';
import 'package:login_riverpod_case_study/product/constants/string_constants.dart';
import 'package:login_riverpod_case_study/product/init/network_manager.dart';
import 'package:login_riverpod_case_study/product/init/users_shared_manager.dart';
import 'package:login_riverpod_case_study/service/users_service.dart';

import '../product/init/shared_manager.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  bool _isLoading = true;
  final IUsersService _service = UsersService(dio: NetworkManager.instance.service);
  List<Data>? _users = [];
  final SharedManager manager = SharedManager();
  late final UsersSharedManager _usersSharedManager = UsersSharedManager(manager);

  @override
  void initState() {
    super.initState();
    Future.microtask(() => initalazeAndSave());
  }

  Future<void> initalazeAndSave() async {
    await manager.init();
    _users = await _service.getUsers();
    _usersSharedManager.saveItems(_users ?? []);
    if (!mounted) return;
    _changeLoading();
  }

  void _changeLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.homeTitle),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _users?.length ?? 0,
              itemBuilder: (context, index) {
                return Padding(
                  padding: context.padding.low,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                    child: Card(
                      color: ColorConstants.purpleDark,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: ColorConstants.grayLighter,
                                  border: Border.all(color: ColorConstants.purpleDark),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                  )),
                              height: MediaQuery.of(context).size.height / 10,
                              child: Text(
                                _users?[index].id.toString() ?? "",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: ListTile(
                              title: Text(
                                ("${_users?[index].firstName ?? ""} ${_users?[index].lastName ?? ""}"),
                                style: _customTextStyle(),
                              ),
                              subtitle: Text(
                                _users?[index].email ?? "",
                                style: _customTextStyle(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  TextStyle _customTextStyle() => const TextStyle(color: ColorConstants.white);
}
