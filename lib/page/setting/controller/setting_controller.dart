import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/models/setting/setting_menu.dart';
import 'package:hello_flutter/util/device_util.dart';
import 'package:hello_flutter/util/image_util.dart';
import 'package:hello_flutter/util/toast_util.dart';
import 'package:image_picker/image_picker.dart';

class SettingController extends GetxController {
  final String headerUrl =
      'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg9.51tietu.net%2Fpic%2F2019-091400%2Feebk0plequ5eebk0plequ5.jpg&refer=http%3A%2F%2Fimg9.51tietu.net&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1641007092&t=4f9c71cd56f65cb2ee2d65131e438e8d';
  final ImagePicker picker = ImagePicker();

  XFile? pickedFile;
  final menuData = <SettingMenuBean>[].obs;
  final TextEditingController nameController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    initData();
  }

  void initData() {
    var header = SettingMenuBean('头像')..photo = ImageUtils.getImageProvider(headerUrl);
    var name = SettingMenuBean('称呼')..name = 'Flutter';
    menuData
      ..add(header)
      ..add(name)
      ..add(SettingMenuBean('账号管理'))
      ..add(SettingMenuBean('问题反馈'))
      ..add(SettingMenuBean('关于我们'));
  }

  Future<void> getImage(bool isCamera) async {
    try {
      pickedFile = await picker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 800,
      );
      if (pickedFile != null) {
        if (DeviceUtil.isWeb) {
          menuData[0] = menuData[0]..photo = NetworkImage(pickedFile!.path);
        } else {
          menuData[0] = menuData[0]..photo = FileImage(File(pickedFile!.path));
        }
      } else {
        menuData[0] = menuData[0]..photo = ImageUtils.getImageProvider(headerUrl);
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
