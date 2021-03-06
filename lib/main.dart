import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/page/splash/splash_page.dart';
import 'package:hello_flutter/res/constant.dart';
import 'package:hello_flutter/util/focus_util.dart';
import 'package:hello_flutter/util/handle_error_util.dart';
import 'package:hello_flutter/util/log_util.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sp_util/sp_util.dart';
import 'package:url_strategy/url_strategy.dart';

import 'net/dio_util.dart';
import 'net/intercept.dart';

Future<void> main() async {
  // 确保初始化完成
  WidgetsFlutterBinding.ensureInitialized();

  // 去除 URL 中的 “#” (hash)，仅针对 Web。默认为 setHashUrlStrategy
  // 注意本地部署和远程部署时`web/index.html`中的 base 标签，
  // https://github.com/flutter/flutter/issues/69760
  setPathUrlStrategy();

  // sp 初始化
  await SpUtil.getInstance();

  // 异常处理
  handleError(() => runApp(HelloApp()));

  // 隐藏状态栏。为启动页、引导页设置。完成后修改回显示状态栏。
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [],
  );
  // TODO: 启动体验不佳。状态栏、导航栏在冷启动开始的一瞬间为黑色，且无法通过隐藏、修改颜色等方式进行处理。。。
  // 相关问题跟踪：https://github.com/flutter/flutter/issues/73351
}

class HelloApp extends StatelessWidget {
  HelloApp({Key? key}) : super(key: key) {
    Logger.init();
    initDio();
  }

  static GlobalKey<NavigatorState> navigateKey = GlobalKey();

  /// 网络请求框架
  void initDio() {
    final List<Interceptor> interceptors = <Interceptor>[];

    // 统一添加身份验证请求头
    interceptors.add(AuthInterceptor());

    // 打印 Log (生产模式去除)
    if (!AppConstant.inProduction) {
      interceptors.add(LoggingInterceptor());
    }

    // 适配数据(根据自己的数据结构，可自行选择添加)
    interceptors.add(AdapterInterceptor());
    configDio(
      baseUrl: 'https://www.baidu.com/',
      interceptors: interceptors,
    );
  }

  @override
  Widget build(BuildContext context) {
    // OKToast 配置
    return OKToast(
      child: _buildGetMaterialApp(),
      backgroundColor: Colors.black45,
      textPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      radius: 6,
      //  全局设置隐藏之前的属性,这里设置后,每次当你显示新的 toast 时,旧的就会被关闭
      dismissOtherOnShow: true,
      position: ToastPosition.center,
    );
  }

  _buildGetMaterialApp() => GetMaterialApp(
        title: 'Hello Flutter',
        debugShowCheckedModeBanner: true,
        home: const SplashPage(),
        defaultTransition: Transition.fadeIn,
        builder: (context, child) {
          return GestureDetector(
            onTap: () => FocusUtil.unfocus(),
            // 保证文字大小不受手机系统设置影响
            // https://www.kikt.top/posts/flutter/layout/dynamic-text/
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            ),
          );
        },
      );
}
