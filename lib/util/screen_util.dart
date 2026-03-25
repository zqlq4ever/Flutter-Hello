import 'package:flutter/material.dart';

/// 屏幕适配工具类
/// 替代 flustars 的 ScreenUtil
class ScreenUtil {
  static final ScreenUtil _instance = ScreenUtil._internal();

  factory ScreenUtil() => _instance;

  ScreenUtil._internal();

  static late double _screenWidth;
  static late double _screenHeight;
  static late double _pixelRatio;
  static late double _statusBarHeight;
  static late double _bottomBarHeight;

  /// 初始化屏幕尺寸信息
  static void init(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _pixelRatio = mediaQuery.devicePixelRatio;
    _statusBarHeight = mediaQuery.padding.top;
    _bottomBarHeight = mediaQuery.padding.bottom;
  }

  /// 获取屏幕宽度
  static double get screenWidth => _screenWidth;

  /// 获取屏幕高度
  static double get screenHeight => _screenHeight;

  /// 获取像素密度
  static double get pixelRatio => _pixelRatio;

  /// 获取状态栏高度
  static double get statusBarHeight => _statusBarHeight;

  /// 获取底部安全区高度
  static double get bottomBarHeight => _bottomBarHeight;

  /// 根据屏幕宽度适配尺寸
  /// [width] 设计稿上的宽度（基于 375 标准）
  static double setWidth(double width) {
    return width * _screenWidth / 375.0;
  }

  /// 根据屏幕高度适配尺寸
  /// [height] 设计稿上的高度（基于 812 标准）
  static double setHeight(double height) {
    return height * _screenHeight / 812.0;
  }

  /// 适配字体大小
  /// [fontSize] 设计稿上的字体大小
  static double setSp(double fontSize) {
    return fontSize * _screenWidth / 375.0;
  }
}

/// 屏幕尺寸扩展
extension ScreenExtension on num {
  /// 宽度适配
  double get w => ScreenUtil.setWidth(toDouble());

  /// 高度适配
  double get h => ScreenUtil.setHeight(toDouble());

  /// 字体大小适配
  double get sp => ScreenUtil.setSp(toDouble());
}
