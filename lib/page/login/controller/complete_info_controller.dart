import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/page/home/page/home_page.dart';
import 'package:hello_flutter/res/constant.dart';
import 'package:hello_flutter/util/device_util.dart';
import 'package:hello_flutter/util/image_util.dart';
import 'package:hello_flutter/util/toast_util.dart';
import 'package:image_picker/image_picker.dart';

class CompleteInfoController extends GetxController {
  final TextEditingController nameController = TextEditingController(text: "");
  final TextEditingController sexController = TextEditingController(text: "");
  final TextEditingController dateController = TextEditingController(text: "");
  final TextEditingController passwordController = TextEditingController(text: "");
  final clickable = false.obs;

  final ImagePicker _picker = ImagePicker();
  ImageProvider imageProvider = ImageUtils.getAssetImage('ic_camera');
  XFile? _pickedFile;

  //  封装成集合,可以观察状态改变。
  final selectImage = <ImageProvider>[ImageUtils.getAssetImage('ic_camera')].obs;

  @override
  void onReady() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
      );
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    });
  }

  void verify() {
    final String name = nameController.text;
    final String sex = sexController.text;
    final String date = dateController.text;
    final String password = passwordController.text;
    bool clickable = true;
    if (name.isEmpty || name.length < 11) {
      clickable = false;
    }
    if (sex.isEmpty) {
      clickable = false;
    }
    if (date.isEmpty) {
      clickable = false;
    }
    if (password.isEmpty || password.length < 6) {
      clickable = false;
    }
    this.clickable.value = clickable;
  }

  void completePersonInfo() {
    SpUtil.putBool(AppConstant.hasLogin, true);
    Get.offAll(() => const HomePage());
  }

  Future<void> getImage(bool isCamera) async {
    try {
      _pickedFile = await _picker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 800,
      );
      if (_pickedFile != null) {
        if (DeviceUtil.isWeb) {
          imageProvider = NetworkImage(_pickedFile!.path);
        } else {
          imageProvider = FileImage(File(_pickedFile!.path));
        }
        selectImage.value = [imageProvider];
      }
    } catch (e) {
      if (e is MissingPluginException) {
        ToastUtil.show('当前平台暂不支持！');
      } else {
        ToastUtil.show('没有权限，无法打开相册！');
      }
    }
  }
}
