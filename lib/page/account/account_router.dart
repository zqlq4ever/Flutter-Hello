import 'package:fluro/fluro.dart';
import 'package:hello_flutter/page/account/page/account_home_page.dart';
import 'package:hello_flutter/page/account/page/update_password_page.dart';
import 'package:hello_flutter/router/core/router_provider.dart';

class AccountRouter implements IRouterProvider {
  static String updatePasswordPage = '/account/updatePassword';
  static String accounthomePage = '/account/home';

  @override
  void initRouter(FluroRouter router) {
    router.define(updatePasswordPage,
        handler: Handler(handlerFunc: (_, __) => const UpdatePasswordPage()));
    router.define(accounthomePage,
        handler: Handler(handlerFunc: (_, __) => const AccountHomePage()));
  }
}
