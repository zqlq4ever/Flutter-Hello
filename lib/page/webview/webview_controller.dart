import 'dart:async';

import 'package:get/get.dart';
import 'package:hello_flutter/util/device_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebController extends GetxController {
  final progress = 0.obs;
  final Completer<WebViewController> webviewController = Completer<WebViewController>();

  @override
  void onInit() {
    super.onInit();
    // Enable hybrid composition.
    if (DeviceUtil.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }
}
