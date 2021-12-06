import 'package:flutter/foundation.dart';

class AppConstant {
  /// App运行在Release环境时，inProduction为true；当App运行在Debug和Profile环境时，inProduction为false
  static const bool inProduction = kReleaseMode;

  static bool isDriverTest = false;

  static const String data = 'data';
  static const String message = 'message';
  static const String code = 'code';

  static const String phone = 'phone';
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';

  static const String theme = 'AppTheme';
  static const String locale = 'locale';
  static const String hasLogin = 'hasLogin';
}
