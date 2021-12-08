import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/page/account/account_router.dart';
import 'package:hello_flutter/page/contact/contact_router.dart';
import 'package:hello_flutter/page/data/data_router.dart';
import 'package:hello_flutter/page/home/home_router.dart';
import 'package:hello_flutter/page/login/login_router.dart';
import 'package:hello_flutter/page/myhome/my_home_page_router.dart';
import 'package:hello_flutter/page/photo_view/photoview_router.dart';
import 'package:hello_flutter/page/setting/setting_router.dart';
import 'package:hello_flutter/page/webview/webview_router.dart';

import 'core/not_found_page.dart';
import 'core/router_provider.dart';

class RoutesManager {
  //  Router 集合
  static final List<IRouterProvider> _listRouter = [];

  //  FluroRouter
  static final FluroRouter router = FluroRouter();

  static void initRoutes() {
    //  指定路由跳转错误返回页
    router.notFoundHandler = Handler(
      handlerFunc: (
        BuildContext? context,
        Map<String, List<String>> params,
      ) {
        return const NotFoundPage();
      },
    );

    //  清空
    _listRouter.clear();

    //  添加各模块路由
    _listRouter.add(LoginRouter());
    _listRouter.add(HomeRouter());
    _listRouter.add(MyHomePageRouter());
    _listRouter.add(SettingRouter());
    _listRouter.add(ContactRouter());
    _listRouter.add(AccountRouter());
    _listRouter.add(WebviewRouter());
    _listRouter.add(PhotoViewRouter());
    _listRouter.add(DataRouter());

    //  初始化路由
    _listRouter.forEach(initRouter);
  }

  static void initRouter(IRouterProvider routerProvider) {
    routerProvider.initRouter(router);
  }
}
