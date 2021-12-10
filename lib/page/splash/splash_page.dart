import 'package:desktop_window/desktop_window.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/page/home/page/home_page.dart';
import 'package:hello_flutter/page/login/page/login_page.dart';
import 'package:hello_flutter/res/constant.dart';
import 'package:hello_flutter/util/device_util.dart';
import 'package:hello_flutter/util/theme_util.dart';

/// 启动页
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top],
      );
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
      _initSplash();
    });

    /// 设置桌面端窗口大小
    if (DeviceUtil.isDesktop) {
      DesktopWindow.setWindowSize(const Size(400, 800));
    }
  }

  void _initSplash() {
    Future<void>.delayed(const Duration(seconds: 1), () {
      bool hasLogin = SpUtil.getBool(AppConstant.hasLogin) ?? false;
      Get.off(() => hasLogin ? const HomePage() : const LoginPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.backgroundColor,
      child: SizedBox(
        width: ScreenUtil.getInstance().screenWidth, // 屏幕宽度
        height: ScreenUtil.getInstance().screenHeight, // 屏幕高度
        child: Image.asset(
          "assets/images/bg.png",
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
