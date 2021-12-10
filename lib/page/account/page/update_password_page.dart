import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/page/account/controller/update_password_controller.dart';
import 'package:hello_flutter/page/login/page/forget_password_page.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/util/other_util.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';
import 'package:hello_flutter/widgets/my_button.dart';
import 'package:hello_flutter/widgets/my_scroll_view.dart';

/// 修改密码
class UpdatePasswordPage extends GetView<UpdatePasswordController> {
  const UpdatePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UpdatePasswordController());
    return Scaffold(
      appBar: const MyAppBar(
        isBack: true,
        centerTitle: '修改密码',
      ),
      body: Container(
        width: ScreenUtil.getInstance().screenWidth,
        height: ScreenUtil.getInstance().screenHeight,
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
        Container(
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
        ),
        Container(
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
        ),
        Container(
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
        ),
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
        Center(
          child: InkWell(
            onTap: () => Get.to(() => const ForgetPasswordPage()),
            child: const Text(
              '忘记原密码?',
              style: TextStyle(
                color: ColorConst.text_gray,
                fontSize: 14,
              ),
            ),
          ),
        )
      ];
}
