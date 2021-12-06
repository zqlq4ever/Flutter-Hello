import 'package:fluro/fluro.dart';
import 'package:hello_flutter/page/setting/page/AboutPage.dart';
import 'package:hello_flutter/page/setting/page/FeedbackPage.dart';
import 'package:hello_flutter/page/setting/page/SettingPage.dart';
import 'package:hello_flutter/router/core/router_provider.dart';

class SettingRouter implements IRouterProvider {
  static String settingPage = '/setting';
  static String aboutPage = '/setting/about';
  static String feedbackPage = '/setting/feedback';

  @override
  void initRouter(FluroRouter router) {
    router.define(settingPage, handler: Handler(handlerFunc: (_, __) => const SettingPage()));
    router.define(aboutPage, handler: Handler(handlerFunc: (_, __) => const AboutPage()));
    router.define(feedbackPage, handler: Handler(handlerFunc: (_, __) => const FeedbackPage()));
  }
}
