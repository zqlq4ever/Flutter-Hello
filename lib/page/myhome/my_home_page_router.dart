import 'package:fluro/fluro.dart';
import 'package:hello_flutter/page/myhome/page/qr_code_scanner_page.dart';
import 'package:hello_flutter/router/core/router_provider.dart';

class MyHomePageRouter implements IRouterProvider {
  static String scan = '/homeItemPage/scan';

  @override
  void initRouter(FluroRouter router) {
    router.define(scan, handler: Handler(handlerFunc: (_, __) => const QrCodeScannerPage()));
  }
}
