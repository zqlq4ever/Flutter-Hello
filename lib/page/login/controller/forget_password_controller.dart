
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/page/login/page/login_page.dart';
import 'package:hello_flutter/util/toast_util.dart';

class ForgetpasswordController extends GetxController {
  final TextEditingController phoneController = TextEditingController(text: "");
  final TextEditingController passwordController = TextEditingController(text: "");
  final TextEditingController passwordConfirmController = TextEditingController(text: "");
  final TextEditingController smsCodeController = TextEditingController(text: "");
  final clickable = false.obs;

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

  void confirm() {
    if (passwordController.text != passwordConfirmController.text) {
      ToastUtil.show('两次密码输入不一致');
      return;
    }
    Get.offAll(() => const LoginPage());
  }

  void verify() {
    final String phone = phoneController.text;
    final String smsCode = smsCodeController.text;
    final String password = passwordController.text;
    final String passwordConfirm = passwordConfirmController.text;
    bool clickable = true;
    if (phone.isEmpty || phone.length < 11) {
      clickable = false;
    }
    if (smsCode.isEmpty || smsCode.length < 6) {
      clickable = false;
    }
    if (password.isEmpty || password.length < 6) {
      clickable = false;
    }
    if (passwordConfirm.isEmpty || passwordConfirm.length < 6) {
      clickable = false;
    }
    this.clickable.value = clickable;
  }


}
