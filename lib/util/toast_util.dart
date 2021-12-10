import 'package:oktoast/oktoast.dart';

/// Toast工具类
class ToastUtil {
  static void show(String? msg, {int duration = 3000}) {
    if (msg == null) {
      return;
    }
    showToast(
      msg,
      duration: Duration(milliseconds: duration),
      dismissOtherToast: true,
    );
  }

  static void cancelToast() {
    dismissAllToast();
  }
}
