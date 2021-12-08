import 'package:fluro/fluro.dart';
import 'package:hello_flutter/page/data/page/data_detail_page.dart';
import 'package:hello_flutter/page/data/page/measure_notice_page.dart';
import 'package:hello_flutter/router/core/router_provider.dart';

class DataRouter implements IRouterProvider {
  static String dataDetailPage = '/data/detail';
  static String noticePage = '/data/notice';

  @override
  void initRouter(FluroRouter router) {
    router.define(noticePage, handler: Handler(handlerFunc: (_, __) => const MeasureNoticePage()));
    router.define(dataDetailPage,
        handler: Handler(handlerFunc: (_, Map<String, List<String>> params) {
      final String title = params['title']?.first ?? '';
      final String name = params['name']?.first ?? '';
      final String id = params['id']?.first ?? '';

      return DataDetailPage(
        title: title,
        name: name,
        id: id,
      );
    }));
  }
}
