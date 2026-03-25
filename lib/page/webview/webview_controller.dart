import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebController extends GetxController {
  final progress = 0.obs;
  late WebViewController webViewController;

  @override
  void onInit() {
    super.onInit();
    _initWebViewController();
  }

  void _initWebViewController() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int p) {
            progress.value = p;
          },
        ),
      )
      ..loadRequest(Uri.parse(Get.arguments['url']));
  }
}
