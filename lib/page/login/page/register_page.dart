import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/page/login/controller/register_controller.dart';
import 'package:hello_flutter/page/login/page/complete_person_info_page.dart';
import 'package:hello_flutter/page/webview/webview_page.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/util/device_util.dart';
import 'package:hello_flutter/util/focus_util.dart';
import 'package:hello_flutter/util/log_util.dart';
import 'package:hello_flutter/util/other_util.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';
import 'package:hello_flutter/widgets/my_button.dart';
import 'package:hello_flutter/widgets/my_scroll_view.dart';
import 'package:hello_flutter/widgets/timer_countdown.dart';

/// 登录 - 注册
class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(RegisterController());
    return Scaffold(
      appBar: const MyAppBar(
        isBack: true,
        centerTitle: '新用户注册',
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: ColorConst.bg_color,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: MyScrollView(
          keyboardConfig: Util.getKeyboardActionsConfig(context, []),
          children: _buildBody,
        ),
      ),
    );
  }

  get _buildBody => <Widget>[
        Gaps.vGap24,
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: TextField(
            controller: controller.phoneController,
            maxLength: 11,
            decoration: const InputDecoration(
              hintText: "请输入手机号",
              counterText: '',
              border: InputBorder.none,
            ),
            // 数字、手机号限制格式为 0 到 9
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
            onChanged: (value) => controller.checkButtonEnable(),
          ),
        ),
        Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.passwordController,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      hintText: "请输入验证码",
                      counterText: '',
                      border: InputBorder.none,
                    ),
                    // 数字、手机号限制格式为0到9
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                    onChanged: (value) => controller.checkButtonEnable(),
                  ),
                ),
                TimerCountDownWidget(onTimerFinish: () {
                  Logger.d('onTimerFinish : 60 s 倒计时完毕。');
                }),
              ],
            )),
        _protocol(),
        Gaps.vGap32,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Obx(
            () => MyButton(
              key: const Key('login'),
              onPressed: controller.nextEnable.value
                  ? () {
                      FocusUtil.unfocus();
                      Get.to(() => const CompletePersonInfoPage());
                    }
                  : null,
              text: '下一步',
              radius: 24,
            ),
          ),
        ),
      ];

  _protocol() => Container(
        padding: const EdgeInsets.only(left: 26),
        alignment: Alignment.bottomCenter,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              () => Checkbox(
                value: controller.checkboxSelected.value,
                onChanged: (state) => controller.setCheck(),
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "同意",
                    style: TextStyle(fontSize: 16, color: ColorConst.text_gray),
                  ),
                  TextSpan(
                    text: "《XXX用户协议》",
                    style: const TextStyle(fontSize: 16, color: ColorConst.app_main),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchWebURL('用户协议', 'https://www.baidu.com');
                      },
                  )
                ],
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      );

  void _launchWebURL(String title, String url) {
    if (DeviceUtil.isMobile) {
      Get.to(
        () => const WebViewPage(),
        arguments: {
          "title": title,
          "url": url,
        },
      );
    } else {
      Util.launchWebURL(url);
    }
  }
}
