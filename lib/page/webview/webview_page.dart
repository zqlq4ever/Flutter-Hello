import 'dart:async';

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
    return FutureBuilder<WebViewController>(
        future: controller.webviewController.future,
        builder: (context, snapshot) {
          return WillPopScope(
            onWillPop: () async {
              if (snapshot.hasData) {
                final bool canGoBack = await snapshot.data!.canGoBack();
                if (canGoBack) {
                  //  网页可以返回时，优先返回上一页
                  await snapshot.data!.goBack();
                  return Future.value(false);
                }
              }
              return Future.value(true);
            },
            child: _page(),
          );
        });
  }

  Scaffold _page() {
    return Scaffold(
      appBar: MyAppBar(
        centerTitle: Get.arguments['title'],
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: Get.arguments['url'],
            javascriptMode: JavascriptMode.unrestricted,
            allowsInlineMediaPlayback: true,
            onWebViewCreated: (WebViewController webViewController) {
              controller.webviewController.complete(webViewController);
            },
            onProgress: (int progress) {
              controller.progress.value = progress;
            },
          ),
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
