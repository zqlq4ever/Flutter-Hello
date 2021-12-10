import 'package:flutter/material.dart';

class FocusUtil {
  static void unfocus() {
    // 使用下面的方式，会触发不必要的 build。
    // FocusScope.of(context).unfocus();
    // https://github.com/flutter/flutter/issues/47128#issuecomment-627551073
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
