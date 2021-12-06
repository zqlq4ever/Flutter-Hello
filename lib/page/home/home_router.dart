import 'package:fluro/fluro.dart';
import 'package:hello_flutter/page/home/page/home_page.dart';
import 'package:hello_flutter/router/core/router_provider.dart';

class HomeRouter implements IRouterProvider {
  static String homePage = '/home';

  @override
  void initRouter(FluroRouter router) {
    router.define(homePage, handler: Handler(handlerFunc: (_, __) => const HomePage()));
  }
}
