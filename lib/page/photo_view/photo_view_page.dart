import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/util/image_util.dart';
import 'package:hello_flutter/util/log_util.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';
import 'package:photo_view/photo_view.dart';

/// 大图浏览
class PhotoViewPage extends StatelessWidget {
  const PhotoViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.d(Get.arguments.toString());
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const MyAppBar(
        backImgColor: Colors.white,
        isBack: true,
        backgroundColor: Colors.transparent,
      ),
      body: PhotoView(
        imageProvider: ImageUtils.getImageProvider(Get.arguments['url']),
      ),
    );
  }
}
