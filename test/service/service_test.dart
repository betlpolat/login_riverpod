import 'package:flutter_test/flutter_test.dart';
import 'package:login_riverpod_case_study/product/init/network_manager.dart';
import 'package:login_riverpod_case_study/service/login_service.dart';

void main() {
  late ILoginService loginService;
  setUp(() {
    loginService = LoginService(dio: NetworkManager.instance.service);
  });
  test('Service Test - post login', () async {
    const email = "eve.holt@reqres.in";
    const password = "cityslicka";
    final response = await loginService.postLogin(email, password);
    expect(response, isTrue);
  });
}
