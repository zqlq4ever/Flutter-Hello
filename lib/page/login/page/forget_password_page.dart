import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/page/login/controller/forget_password_controller.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/util/other_util.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';
import 'package:hello_flutter/widgets/my_button.dart';
import 'package:hello_flutter/widgets/my_scroll_view.dart';

/// 登录 - 忘记密码
class ForgetPasswordPage extends GetView<ForgetpasswordController> {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ForgetpasswordController());
    return Scaffold(
      appBar: const MyAppBar(
        isBack: true,
        centerTitle: '忘记密码',
      ),
      body: Container(
        width: ScreenUtil.getInstance().screenWidth, // 屏幕宽度
        height: ScreenUtil.getInstance().screenHeight, // 屏幕高度
        color: ColorConst.bg_color,
        child: MyScrollView(
          keyboardConfig: Util.getKeyboardActionsConfig(context, []),
          children: _buildBody,
        ),
      ),
    );
  }

  List<Widget> get _buildBody => <Widget>[
        Gaps.vGap16,
        _inputPhone(),
        _inputSmsCode(),
        Gaps.vGap16,
        _inputPassword(),
        _inputPasswordAgain(),
        Gaps.vGap40,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Obx(() {
            return MyButton(
              onPressed: controller.clickable.value ? controller.confirm : null,
              text: '确定',
              radius: 24,
            );
          }),
        ),
        Gaps.vGap16,
      ];

  Container _inputPasswordAgain() {
    return Container(
      color: Colors.white,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Center(
        child: TextField(
          controller: controller.passwordConfirmController,
          maxLength: 16,
          decoration: const InputDecoration(
            hintText: "请再次输入密码",
            counterText: '',
            border: InputBorder.none,
          ),
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[\u4e00-\u9fa5]'))],
          onChanged: (_) => controller.verify(),
        ),
      ),
    );
  }

  Container _inputPassword() {
    return Container(
      color: Colors.white,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Center(
        child: TextField(
          controller: controller.passwordController,
          maxLength: 16,
          decoration: const InputDecoration(
            hintText: "请输入密码",
            counterText: '',
            border: InputBorder.none,
          ),
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[\u4e00-\u9fa5]'))],
          onChanged: (_) => controller.verify(),
        ),
      ),
    );
  }

  _inputSmsCode() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.smsCodeController,
                maxLength: 6,
                decoration: const InputDecoration(
                  hintText: "请输入验证码",
                  counterText: '',
                  border: InputBorder.none,
                ),
                // 数字、手机号限制格式为0到9
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                onChanged: (_) => controller.verify(),
              ),
            ),
            const Text(
              "获取验证码",
              style: TextStyle(color: ColorConst.app_main),
            ),
          ],
        ),
      );

  Container _inputPhone() {
    return Container(
      color: Colors.white,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Center(
        child: TextField(
          controller: controller.phoneController,
          maxLength: 11,
          decoration: const InputDecoration(
            hintText: "请输入手机号",
            counterText: '',
            border: InputBorder.none,
          ),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
          onChanged: (_) => controller.verify(),
        ),
      ),
    );
  }
}
