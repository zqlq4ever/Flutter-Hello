import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hello_flutter/res/constant.dart';
import 'package:hello_flutter/util/focus_util.dart';

class LoginController extends GetxController with GetSingleTickerProviderStateMixin {
  //  复选框状态
  final checkboxSelected = false.obs;

  //  登录按钮是否可点击
  final loginEnable = false.obs;

  TabController? tabController;
  final TextEditingController phoneController = TextEditingController(text: "");
  final TextEditingController passwordController = TextEditingController(text: "");

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);

    // 每次`checkboxSelected`变化时调用。
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
      SpUtil.putBool(AppConstant.hasLogin, false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    passwordController.dispose();
    tabController?.dispose();
  }

  void setCheck() {
    checkboxSelected.value = !checkboxSelected.value;
  }

  void checkButtonEnable() {
    final String name = phoneController.text;
    final String password = passwordController.text;
    bool clickable = true;
    if (name.isEmpty || name.length < 11) {
      clickable = false;
    }
    if (password.isEmpty || password.length < 6) {
      clickable = false;
    }
    if (!checkboxSelected.value) {
      clickable = false;
    }
    loginEnable.value = clickable;
  }
}
