import 'package:common_utils/common_utils.dart';
import 'package:fluro/fluro.dart';
import 'package:hello_flutter/page/photo_view/photo_view_page.dart';
import 'package:hello_flutter/router/core/router_provider.dart';

class PhotoViewRouter implements IRouterProvider {
  static String photoViewPage = '/photoView';

  @override
  void initRouter(FluroRouter router) {
    router.define(photoViewPage,
        handler: Handler(handlerFunc: (_, Map<String, List<String>> params) {
      final String url = EncryptUtil.decodeBase64(params['url']?.first ?? '');
      return PhotoViewPage(url: url);
    }));
  }
}
