import 'package:fluro/fluro.dart';
import 'package:hello_flutter/page/webview/webview_page.dart';
import 'package:hello_flutter/router/core/router_provider.dart';

class WebviewRouter implements IRouterProvider {
  static String webViewPage = '/webView';

  @override
  void initRouter(FluroRouter router) {
    router.define(webViewPage, handler: Handler(handlerFunc: (_, params) {
      final String title = params['title']?.first ?? '';
      final String url = params['url']?.first ?? '';
      return WebViewPage(title: title, url: url);
    }));
  }
}
