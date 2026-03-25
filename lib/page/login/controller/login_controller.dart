import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/net/dio_util.dart';
import 'package:hello_flutter/res/constant.dart';
import 'package:hello_flutter/util/log_util.dart';
import 'package:sp_util/sp_util.dart';

class LoginController extends GetxController with GetSingleTickerProviderStateMixin {
  //  复选框状态
  final checkboxSelected = false.obs;

  //  登录按钮是否可点击
  final loginEnable = false.obs;

  //  密码登录
  final isLoginByPassword = true.obs;

  TabController? tabController;
  final TextEditingController phoneController = TextEditingController(text: "");
  final TextEditingController passwordController = TextEditingController(text: "");
  final TextEditingController smsController = TextEditingController(text: "");

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);

    // 每次变化时调用。
    everAll([isLoginByPassword, checkboxSelected], (_) => checkButtonEnable());
  }

  @override
  void onReady() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    smsController.dispose();
    tabController?.dispose();
    super.onClose();
  }

  void setCheck() {
    checkboxSelected.value = !checkboxSelected.value;
  }

  void checkButtonEnable() {
    Logger.d('checkButtonEnable');
    final String name = phoneController.text;
    final String password = passwordController.text;
    final String smsCode = smsController.text;
    bool clickable = true;
    if (name.isEmpty || name.length < 11) {
      clickable = false;
    }
    if (!checkboxSelected.value) {
      clickable = false;
    }
    if (isLoginByPassword.value) {
      if (password.isEmpty || password.length < 6) {
        clickable = false;
      }
    } else {
      if (smsCode.isEmpty || smsCode.length < 6) {
        clickable = false;
      }
    }
    loginEnable.value = clickable;
  }

  void login() {
    final String name = phoneController.text;
    final String password = passwordController.text;
    final String smsCode = smsController.text;
    DioUtil.instance.dio.request('path');
  }
}
