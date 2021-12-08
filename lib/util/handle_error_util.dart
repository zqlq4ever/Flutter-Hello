import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:hello_flutter/res/constant.dart';

/// 捕获全局异常，进行统一处理。
void handleError(void Function() body) {
  /// 重写 Flutter 异常回调 FlutterError.onError
  FlutterError.onError = (FlutterErrorDetails details) {
    if (!AppConstant.inProduction) {
      // debug 时，直接将异常信息打印。
      FlutterError.dumpErrorToConsole(details);
    } else {
      // release 时，将异常交由 zone 统一处理。
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };

  /// 使用 runZonedGuarded 捕获 Flutter 未捕获的异常
  runZonedGuarded(body, (Object error, StackTrace stackTrace) async {
    await _reportError(error, stackTrace);
  });
}

Future<void> _reportError(Object error, StackTrace stackTrace) async {
  if (!AppConstant.inProduction) {
    debugPrintStack(
      stackTrace: stackTrace,
      label: error.toString(),
      maxFrames: 100,
    );
  } else {
    /// 将异常信息收集并上传到服务器。可以直接使用类似`flutter_bugly`插件处理异常上报。
  }
}
