import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_flutter/res/colors.dart';

import 'device_util.dart';

class ThemeUtil {
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color? getDarkColor(BuildContext context, Color darkColor) {
    return isDark(context) ? darkColor : null;
  }

  static Color? getIconColor(BuildContext context) {
    return isDark(context) ? ColorConst.dark_text : null;
  }

  static Color getStickyHeaderColor(BuildContext context) {
    return isDark(context) ? ColorConst.dark_bg_gray_ : ColorConst.bg_gray_;
  }

  static Color getDialogTextFieldColor(BuildContext context) {
    return isDark(context) ? ColorConst.dark_bg_gray_ : ColorConst.bg_gray;
  }

  static Color? getKeyboardActionsColor(BuildContext context) {
    return isDark(context) ? ColorConst.dark_bg_color : Colors.grey[200];
  }

  static Timer? _timer;

  /// 设置 NavigationBar 样式，使得导航栏颜色与深色模式的设置相符。
  static void setSystemNavigationBar(ThemeMode mode, {BuildContext? context}) {
    /// 主题切换动画（AnimatedTheme）时间为200毫秒，延时设置导航栏颜色，这样过渡相对自然。
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 200), () {
      bool isDarkMode = false;
      final Brightness platformBrightness = context != null
          ? View.of(context).platformDispatcher.platformBrightness
          : PlatformDispatcher.instance.platformBrightness;
      if (mode == ThemeMode.dark ||
          (mode == ThemeMode.system && platformBrightness == Brightness.dark)) {
        isDarkMode = true;
      }
      setSystemBarStyle(isDark: isDarkMode, context: context);
    });
  }

  /// 设置 StatusBar、NavigationBar 样式。(仅针对安卓)
  /// 本项目在 android MainActivity 中已设置，不需要覆盖设置。
  static void setSystemBarStyle({bool? isDark, BuildContext? context}) {
    if (DeviceUtil.isAndroid) {
      final Brightness platformBrightness = context != null
          ? View.of(context).platformDispatcher.platformBrightness
          : PlatformDispatcher.instance.platformBrightness;
      final bool isDarkMode = isDark ?? platformBrightness == Brightness.dark;
      final SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        /// 透明状态栏
        statusBarColor: Colors.transparent,
        systemNavigationBarColor:
            isDarkMode ? ColorConst.dark_bg_color : Colors.white,
        systemNavigationBarIconBrightness:
            isDarkMode ? Brightness.light : Brightness.dark,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}

extension ThemeExtension on BuildContext {
  bool get isDark => ThemeUtil.isDark(this);

  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;

  Color get dialogBackgroundColor => Theme.of(this).canvasColor;
}
