import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_flutter/page/home/home_router.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/constant.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/router/fluro_navigate_util.dart';
import 'package:hello_flutter/util/change_notifier_manage.dart';
import 'package:hello_flutter/util/device_util.dart';
import 'package:hello_flutter/util/other_util.dart';
import 'package:hello_flutter/widgets/load_image.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';
import 'package:hello_flutter/widgets/my_button.dart';
import 'package:hello_flutter/widgets/my_scroll_view.dart';
import 'package:sp_util/sp_util.dart';

import '../login_router.dart';

/// 登录
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with ChangeNotifierMixin<LoginPage>, TickerProviderStateMixin {
  //  定义一个 controller
  TabController? tabController;
  final TextEditingController _phoneController = TextEditingController(text: "");
  final TextEditingController _passwordController = TextEditingController(text: "");
  final FocusNode _nodePhone = FocusNode();
  final FocusNode _nodePassword = FocusNode();

  //  登录按钮是否可点击
  bool _clickable = false;

  //  选中状态
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
  void dispose() {
    _nodePhone.dispose();
    _nodePassword.dispose();
    super.dispose();
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
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

  void _login() {
    NavigateUtil.push(context, HomeRouter.homePage, replace: true);
    SpUtil.putString(AppConstant.phone, _phoneController.text);
    SpUtil.putBool(AppConstant.hasLogin, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const MyAppBar(
        isBack: false,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MyScrollView(
            keyboardConfig: Util.getKeyboardActionsConfig(
              context,
              <FocusNode>[_nodePhone, _nodePassword],
            ),
            children: _buildBody,
          ),
          _protocol(),
        ],
      ),
    );
  }

  get _buildBody => <Widget>[
        Gaps.vGap16,
        _logo(),
        Gaps.vGap40,
        tabBar(),
        Gaps.vGap24,
        _inputPhone(),
        Gaps.vGap8,
        _password(),
        Gaps.vGap40,
        _loginButton(),
        Gaps.vGap16,
        _register(),
      ];

  _protocol() => Container(
        alignment: Alignment.bottomCenter,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
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
                  const TextSpan(
                    text: "登录代表你已同意",
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

  _password() => Row(
        children: [
          Expanded(child: _inputPassword()),
          _forgetPassword(),
        ],
      );

  tabBar() => Center(
        child: TabBar(
          onTap: (tab) {
            print(tab);
          },
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 16),
          isScrollable: true,
          controller: tabController,
          labelColor: ColorConst.app_main,
          indicatorWeight: 3,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
          unselectedLabelColor: ColorConst.text_gray,
          indicatorColor: ColorConst.app_main,
          tabs: const [
            Tab(text: "密码登录"),
            Tab(text: "验证码登录"),
          ],
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '注册',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 17,
              ),
            ),
          ),
          onTap: () => NavigateUtil.push(context, LoginRouter.register),
        ),
      );

  _forgetPassword() => InkWell(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '忘记密码',
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
        onTap: () => NavigateUtil.push(context, LoginRouter.forgetPassword),
      );

  _loginButton() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: MyButton(
          key: const Key('login'),
          onPressed: _clickable ? _login : null,
          text: '登录',
          radius: 24,
        ),
      );

  _inputPassword() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: TextField(
          focusNode: _nodePassword,
          controller: _passwordController,
          maxLength: 16,
          decoration: const InputDecoration(
            contentPadding:EdgeInsets.symmetric(vertical: 8.0),
            hintText: "请输入密码",
            counterText: '',
            border: InputBorder.none,
          ),
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[\u4e00-\u9fa5]'))],
        ),
      );

  _inputPhone() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: TextField(
          focusNode: _nodePhone,
          controller: _phoneController,
          maxLength: 11,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
            hintText: "请输入手机号",
            counterText: '',
            border: InputBorder.none,
          ),
          // 数字、手机号限制格式为0到9
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
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
