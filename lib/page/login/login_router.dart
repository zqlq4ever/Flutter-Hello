import 'package:fluro/fluro.dart';
import 'package:hello_flutter/page/login/page/complete_person_info_page.dart';
import 'package:hello_flutter/page/login/page/default_header_page.dart';
import 'package:hello_flutter/page/login/page/forget_password_page.dart';
import 'package:hello_flutter/page/login/page/register_page.dart';
import 'package:hello_flutter/router/core/router_provider.dart';

import 'page/login_page.dart';

class LoginRouter implements IRouterProvider {
  static String loginPage = '/login/home';
  static String register = '/login/register';
  static String completePersonInfo = '/login/register/completePersonInfo';
  static String forgetPassword = '/login/forgetPassword';
  static String defautHeader = '/login/register/defautHeader';

  @override
  void initRouter(FluroRouter router) {
    router.define(loginPage, handler: Handler(handlerFunc: (_, __) => const LoginPage()));
    router.define(register, handler: Handler(handlerFunc: (_, __) => const RegisterPage()));
    router.define(forgetPassword,
        handler: Handler(handlerFunc: (_, __) => const forgetPasswordPage()));
    router.define(completePersonInfo,
        handler: Handler(handlerFunc: (_, __) => const CompletePersonInfoPage()));
    router.define(defautHeader, handler: Handler(handlerFunc: (_, __) => const DefautHeaderPage()));
  }
}
