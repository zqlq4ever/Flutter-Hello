import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/page/home/page/home_page.dart';
import 'package:hello_flutter/page/login/controller/login_controller.dart';
import 'package:hello_flutter/page/login/page/forget_password_page.dart';
import 'package:hello_flutter/page/login/page/register_page.dart';
import 'package:hello_flutter/page/webview/webview_page.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/constant.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/util/device_util.dart';
import 'package:hello_flutter/util/focus_util.dart';
import 'package:hello_flutter/util/log_util.dart';
import 'package:hello_flutter/util/other_util.dart';
import 'package:hello_flutter/widgets/keep_alive_wrapper.dart';
import 'package:hello_flutter/widgets/load_image.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';
import 'package:hello_flutter/widgets/my_button.dart';
import 'package:hello_flutter/widgets/my_scroll_view.dart';
import 'package:hello_flutter/widgets/timer_countdown.dart';
import 'package:sp_util/sp_util.dart';

/// 登录
class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const MyAppBar(
        isBack: false,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MyScrollView(
            keyboardConfig: Util.getKeyboardActionsConfig(context, []),
            children: _buildBody,
          ),
          _protocol(),
        ],
      ),
    );
  }

  void _login() {
    Get.offAll(() => const HomePage());
    SpUtil.putString(AppConstant.phone, controller.phoneController.text);
    SpUtil.putBool(AppConstant.hasLogin, true);
  }

  get _buildBody => <Widget>[
        Gaps.vGap16,
        _logo(),
        Gaps.vGap40,
        tabBar(),
        Gaps.vGap24,
        _tabBarView(),
        Gaps.vGap40,
        _loginButton(),
        Gaps.vGap16,
        _register(),
      ];

  _tabBarView() {
    return SizedBox(
      height: 100,
      child: TabBarView(
        //构建
        controller: controller.tabController,
        children: [
          //  密码登录
          KeepAliveWrapper(
            child: Column(
              children: [
                _inputPhone(),
                _password(),
              ],
            ),
          ),
          //  验证码登录
          KeepAliveWrapper(
            child: Column(
              children: [
                _inputPhone(),
                _smsCode(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _smsCode() {
    return Container(
      height: 50,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.smsController,
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
      ),
    );
  }

  _protocol() => Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Checkbox(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  value: controller.checkboxSelected.value,
                  onChanged: (state) {
                    controller.setCheck();
                  },
                )),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "登录代表你已同意",
                    style: TextStyle(fontSize: 16, color: ColorConst.text),
                  ),
                  TextSpan(
                    text: "《用户协议》",
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

  _password() => Row(
        children: [
          Expanded(child: _inputPassword()),
          _forgetPassword(),
        ],
      );

  tabBar() => Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Center(
          child: TabBar(
            onTap: (tab) {
              Logger.d('点击了 $tab');
              controller.isLoginByPassword.value = tab == 0;
            },
            labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 14),
            labelColor: ColorConst.app_main,
            unselectedLabelColor: ColorConst.text,
            isScrollable: true,
            controller: controller.tabController,
            indicatorWeight: 3,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
            indicatorColor: ColorConst.app_main,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(text: "密码登录"),
              Tab(text: "验证码登录"),
            ],
          ),
        ),
      );

  _logo() => const Center(
        child: LoadAssetImage(
          'ic_logo',
          width: 80,
          height: 80,
        ),
      );

  _register() => Center(
        child: InkWell(
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '注册',
              style: TextStyle(
                color: ColorConst.app_main,
                fontSize: 17,
              ),
            ),
          ),
          onTap: () {
            FocusUtil.unfocus();
            Get.to(() => const RegisterPage());
          },
        ),
      );

  _forgetPassword() => InkWell(
        child: Container(
          alignment: Alignment.center,
          color: Colors.white,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: const Text(
            '忘记密码',
            style: TextStyle(fontSize: 14, color: ColorConst.text_gray),
          ),
        ),
        onTap: () {
          FocusUtil.unfocus();
          Get.to(() => const ForgetPasswordPage());
        },
      );

  _loginButton() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Obx(() => MyButton(
              key: const Key('login'),
              onPressed: controller.loginEnable.value ? _login : null,
              text: '登录',
              radius: 24,
            )),
      );

  _inputPassword() => Container(
        height: 50,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: TextField(
          controller: controller.passwordController,
          maxLength: 16,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
            hintText: "请输入密码",
            counterText: '',
            border: InputBorder.none,
          ),
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[\u4e00-\u9fa5]'))],
          onChanged: (value) {
            controller.checkButtonEnable();
          },
        ),
      );

  _inputPhone() => Container(
        height: 50,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: TextField(
          controller: controller.phoneController,
          maxLength: 11,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
            hintText: "请输入手机号",
            counterText: '',
            border: InputBorder.none,
          ),
          // 数字、手机号限制格式为 0 到 9
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
          onChanged: (value) {
            controller.checkButtonEnable();
          },
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
