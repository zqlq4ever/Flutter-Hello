import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/page/webview/webview_controller.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends GetView<WebController> {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(WebController());
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final bool canGoBack = await controller.webViewController.canGoBack();
        if (canGoBack) {
          await controller.webViewController.goBack();
        } else {
          Get.back();
        }
      },
      child: _page(),
    );
  }

  Scaffold _page() {
    return Scaffold(
      appBar: MyAppBar(
        centerTitle: Get.arguments['title'],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller.webViewController),
          Obx(() {
            return Visibility(
              visible: controller.progress.value != 100,
              child: LinearProgressIndicator(
                value: controller.progress.value / 100,
                backgroundColor: Colors.transparent,
                minHeight: 2,
              ),
            );
          }),
        ],
      ),
    );
  }
}
