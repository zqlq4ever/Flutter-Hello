import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/constant.dart';

class DefaultHeaderController extends GetxController {
  //  选择的头像 index
  final selectedIndex = 0.obs;

  final List<String> data = [
    'ic_header_boy',
    'ic_header_dad',
    'ic_header_girl',
    'ic_header_mom',
    'ic_header_grandma',
    'ic_header_grandpa',
  ];

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

  void setSelectIndex(int index) {
    selectedIndex.value = index;
  }

}
