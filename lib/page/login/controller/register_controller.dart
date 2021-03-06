import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController with GetSingleTickerProviderStateMixin {
  //  复选框状态
  final checkboxSelected = false.obs;

  //  注册按钮是否可点击
  final nextEnable = false.obs;

  TabController? tabController;
  final TextEditingController phoneController = TextEditingController(text: "");
  final TextEditingController smsController = TextEditingController(text: "");

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    ever(checkboxSelected, (_) => checkButtonEnable());
  }

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

  @override
  void onClose() {
    phoneController.dispose();
    smsController.dispose();
    tabController?.dispose();
  }

  void setCheck() {
    checkboxSelected.value = !checkboxSelected.value;
  }

  void checkButtonEnable() {
    final String name = phoneController.text;
    final String smsCode = smsController.text;
    bool clickable = true;
    if (name.isEmpty || name.length < 11) {
      clickable = false;
    }
    if (smsCode.isEmpty || smsCode.length < 6) {
      clickable = false;
    }
    if (!checkboxSelected.value) {
      clickable = false;
    }
    nextEnable.value = clickable;
  }
}
