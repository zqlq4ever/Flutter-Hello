import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_flutter/util/toast_util.dart';

/// 双击返回退出
class DoubleTapBackExitApp extends StatefulWidget {
  const DoubleTapBackExitApp({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 3000),
  });

  final Widget child;

  /// 两次点击返回按钮的时间间隔
  final Duration duration;

  @override
  State<DoubleTapBackExitApp> createState() => _DoubleTapBackExitAppState();
}

class _DoubleTapBackExitAppState extends State<DoubleTapBackExitApp> {
  DateTime? _lastTime;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        final bool shouldPop = await _isExit();
        if (shouldPop && mounted) {
          await SystemNavigator.pop();
        }
      },
      child: widget.child,
    );
  }

  Future<bool> _isExit() async {
    if (_lastTime == null || DateTime.now().difference(_lastTime!) > widget.duration) {
      _lastTime = DateTime.now();
      ToastUtil.show('再次点击退出应用');
      return false;
    }
    ToastUtil.cancelToast();
    return true;
  }
}
