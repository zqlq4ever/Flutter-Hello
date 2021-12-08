import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/router/fluro_navigate_util.dart';
import 'package:hello_flutter/util/change_notifier_manage.dart';
import 'package:hello_flutter/util/other_util.dart';
import 'package:hello_flutter/util/toast_util.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';
import 'package:hello_flutter/widgets/my_button.dart';
import 'package:hello_flutter/widgets/my_scroll_view.dart';

import '../login_router.dart';

/// 登录 - 忘记密码
class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage>
    with ChangeNotifierMixin<ForgetPasswordPage> {
  //  定义一个 controller
  final TextEditingController _phoneController = TextEditingController(text: "");
  final TextEditingController _passwordController = TextEditingController(text: "");
  final TextEditingController _passwordConfirmController = TextEditingController(text: "");
  final TextEditingController _smsCodeController = TextEditingController(text: "");
  final FocusNode _nodePhone = FocusNode();
  final FocusNode _nodePassword = FocusNode();
  final FocusNode _nodePasswordComfirm = FocusNode();
  final FocusNode _nodeSmsCode = FocusNode();
  bool _clickable = false;

  @override
  Map<ChangeNotifier, List<VoidCallback>?>? changeNotifier() {
    final List<VoidCallback> callbacks = <VoidCallback>[_verify];
    return <ChangeNotifier, List<VoidCallback>?>{
      _phoneController: callbacks,
      _passwordController: callbacks,
      _passwordConfirmController: callbacks,
      _smsCodeController: callbacks,
      _nodePhone: null,
      _nodePassword: null,
      _nodePasswordComfirm: null,
      _nodeSmsCode: null,
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
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nodePhone.dispose();
    _nodePassword.dispose();
    _nodePasswordComfirm.dispose();
    _nodeSmsCode.dispose();
  }

  void _verify() {
    final String phone = _phoneController.text;
    final String smsCode = _smsCodeController.text;
    final String password = _passwordController.text;
    final String passwordConfirm = _passwordConfirmController.text;
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

    /// 状态不一样再刷新，避免不必要的setState
    if (clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }

  void _confirm() {
    if (_passwordController.text != _passwordConfirmController.text) {
      ToastUtil.show('两次密码输入不一致');
      return;
    }
    NavigateUtil.push(context, LoginRouter.loginPage, clearStack: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        isBack: true,
        centerTitle: '忘记密码',
      ),
      body: Container(
        width: MediaQuery.of(context).size.width, // 屏幕宽度
        height: MediaQuery.of(context).size.height, // 屏幕高度
        color: ColorConst.bg_color,
        child: MyScrollView(
          keyboardConfig:
              Util.getKeyboardActionsConfig(context, <FocusNode>[_nodePhone, _nodePassword]),
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
          child: MyButton(
            key: const Key('comfirm'),
            onPressed: _clickable ? _confirm : null,
            text: '确定',
            radius: 24,
          ),
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
          focusNode: _nodePasswordComfirm,
          controller: _passwordConfirmController,
          maxLength: 16,
          decoration: const InputDecoration(
            hintText: "请再次输入密码",
            counterText: '',
            border: InputBorder.none,
          ),
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[\u4e00-\u9fa5]'))],
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
          focusNode: _nodePassword,
          controller: _passwordController,
          maxLength: 16,
          decoration: const InputDecoration(
            hintText: "请输入密码",
            counterText: '',
            border: InputBorder.none,
          ),
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[\u4e00-\u9fa5]'))],
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
                focusNode: _nodeSmsCode,
                controller: _smsCodeController,
                maxLength: 6,
                decoration: const InputDecoration(
                  hintText: "请输入验证码",
                  counterText: '',
                  border: InputBorder.none,
                ),
                // 数字、手机号限制格式为0到9
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
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
          focusNode: _nodePhone,
          controller: _phoneController,
          maxLength: 11,
          decoration: const InputDecoration(
            hintText: "请输入手机号",
            counterText: '',
            border: InputBorder.none,
          ),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
        ),
      ),
    );
  }
}
