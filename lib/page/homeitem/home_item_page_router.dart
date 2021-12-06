import 'package:fluro/fluro.dart';
import 'package:hello_flutter/page/homeitem/page/Qr_Code_Scanner_Page.dart';
import 'package:hello_flutter/router/core/router_provider.dart';

class HomeItemPageRouter implements IRouterProvider {
  static String scan = '/homeItemPage/scan';

  @override
  void initRouter(FluroRouter router) {
    router.define(scan, handler: Handler(handlerFunc: (_, __) => const QrCodeScannerPage()));
  }
}
