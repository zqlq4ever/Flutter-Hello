import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/l10n/app_localizations.dart';
import 'package:hello_flutter/page/splash/splash_page.dart';
import 'package:hello_flutter/res/constant.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/util/focus_util.dart';
import 'package:hello_flutter/util/handle_error_util.dart';
import 'package:hello_flutter/util/log_util.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sp_util/sp_util.dart';

import 'net/dio_util.dart';
import 'net/intercept.dart';

void main() {
  // 捕获 Flutter 框架异常
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    Logger.e('Flutter Error: ${details.exception}');
  };

  // 捕获异步异常
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    Logger.e('Async Error: $error\nStack: $stack');
    return true;
  };

  // 异常处理 - 使用 runZonedGuarded 包裹整个应用生命周期
  handleError(() async {
    // 确保初始化完成
    WidgetsFlutterBinding.ensureInitialized();

    // sp 初始化
    await SpUtil.getInstance();

    // 统一系统栏策略，避免 main/splash 反复切换导致闪烁。
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: ColorConst.bg_color,
      ),
    );

    runApp(const HelloApp());
  });
}

class HelloApp extends StatelessWidget {
  const HelloApp({Key? key}) : super(key: key);

  @override
  StatelessElement createElement() {
    Logger.init();
    initDio();
    return super.createElement();
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
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        defaultTransition: Transition.fadeIn,
        navigatorObservers: [FlutterSmartDialog.observer],
        builder: (context, child) {
          // 初始化 FlutterSmartDialog
          child = FlutterSmartDialog.init()(context, child);
          return GestureDetector(
            onTap: () => FocusUtil.unfocus(),
            // 保证文字大小不受手机系统设置影响
            // https://www.kikt.top/posts/flutter/layout/dynamic-text/
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child,
            ),
          );
        },
      );
}
