import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/router/fluro_navigate_util.dart';
import 'package:hello_flutter/util/change_notifier_manage.dart';
import 'package:hello_flutter/util/device_util.dart';
import 'package:hello_flutter/util/other_util.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';
import 'package:hello_flutter/widgets/my_button.dart';
import 'package:hello_flutter/widgets/my_scroll_view.dart';

import '../login_router.dart';

/// 登录 - 注册
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with ChangeNotifierMixin<RegisterPage> {
  //  定义一个 controller
  final TextEditingController _phoneController = TextEditingController(text: "");
  final TextEditingController _passwordController = TextEditingController(text: "");
  final FocusNode _nodePhone = FocusNode();
  final FocusNode _nodePassword = FocusNode();
  bool _clickable = false;
  bool checkboxSelected = false;

  @override
  Map<ChangeNotifier, List<VoidCallback>?>? changeNotifier() {
    final List<VoidCallback> callbacks = <VoidCallback>[_verify];
    return <ChangeNotifier, List<VoidCallback>?>{
      _phoneController: callbacks,
      _passwordController: callbacks,
      _nodePhone: null,
      _nodePassword: null,
    };
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top],
      );
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nodePhone.dispose();
    _nodePassword.dispose();
  }

  void _verify() {
    final String name = _phoneController.text;
    final String password = _passwordController.text;
    bool clickable = true;
    if (name.isEmpty || name.length < 11) {
      clickable = false;
    }
    if (password.isEmpty || password.length < 6) {
      clickable = false;
    }

    /// 状态不一样再刷新，避免不必要的setState
    if (clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }

  void _completePersonInfo() {
    NavigateUtil.push(context, LoginRouter.completePersonInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        isBack: true,
        centerTitle: '新用户注册',
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: ColorConst.bg_color,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: MyScrollView(
          keyboardConfig: Util.getKeyboardActionsConfig(
            context,
            <FocusNode>[_nodePhone, _nodePassword],
          ),
          children: _buildBody,
        ),
      ),
    );
  }

  get _buildBody => <Widget>[
        Gaps.vGap24,
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: TextField(
            focusNode: _nodePhone,
            controller: _phoneController,
            maxLength: 11,
            decoration: InputDecoration(
              hintText: "请输入手机号",
              counterText: '',
              border: InputBorder.none,
            ),
            // 数字、手机号限制格式为 0 到 9
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
          ),
        ),
        Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: _nodePassword,
                    controller: _passwordController,
                    maxLength: 6,
                    decoration: InputDecoration(
                      hintText: "请输入验证码",
                      counterText: '',
                      border: InputBorder.none,
                    ),
                    // 数字、手机号限制格式为0到9
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                  ),
                ),
                Text(
                  "获取验证码",
                  style: TextStyle(color: ColorConst.app_main),
                ),
              ],
            )),
        _protocol(),
        Gaps.vGap32,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: MyButton(
            key: const Key('login'),
            onPressed: _clickable ? _completePersonInfo : null,
            text: '下一步',
            radius: 24,
          ),
        ),
      ];

  _protocol() => Container(
        padding: EdgeInsets.only(left: 26),
        alignment: Alignment.bottomCenter,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: checkboxSelected,
              onChanged: (state) {
                setState(() {
                  checkboxSelected = !checkboxSelected;
                });
              },
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "同意",
                    style: TextStyle(fontSize: 16, color: ColorConst.text_gray),
                  ),
                  TextSpan(
                    text: "《XXX用户协议》",
                    style: TextStyle(fontSize: 16, color: ColorConst.app_main),
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
      NavigateUtil.goWebViewPage(context, title, url);
    } else {
      Util.launchWebURL(url);
    }
  }
}
