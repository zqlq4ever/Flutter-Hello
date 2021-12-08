import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_flutter/page/login/login_router.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/router/fluro_navigate_util.dart';
import 'package:hello_flutter/util/change_notifier_manage.dart';
import 'package:hello_flutter/util/other_util.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';
import 'package:hello_flutter/widgets/my_button.dart';
import 'package:hello_flutter/widgets/my_scroll_view.dart';

/// 修改密码
class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({Key? key}) : super(key: key);

  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage>
    with ChangeNotifierMixin<UpdatePasswordPage> {
  //  定义一个 controller
  final TextEditingController _phoneController = TextEditingController(text: "");
  final TextEditingController _passwordController = TextEditingController(text: "");
  final TextEditingController _passwordConfimeController = TextEditingController(text: "");
  final FocusNode _nodePhone = FocusNode();
  final FocusNode _nodePassword = FocusNode();
  final FocusNode _nodePasswordComfirm = FocusNode();
  bool _clickable = false;

  @override
  Map<ChangeNotifier, List<VoidCallback>?>? changeNotifier() {
    final List<VoidCallback> callbacks = <VoidCallback>[_verify];
    return <ChangeNotifier, List<VoidCallback>?>{
      _phoneController: callbacks,
      _passwordController: callbacks,
      _passwordConfimeController: callbacks,
      _nodePhone: null,
      _nodePassword: null,
      _nodePasswordComfirm: null,
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

  void _confirm() {
    NavigateUtil.push(context, LoginRouter.loginPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        isBack: true,
        centerTitle: '修改密码',
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
        Container(
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
        ),
        Container(
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
        ),
        Container(
          color: Colors.white,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Center(
            child: TextField(
              focusNode: _nodePasswordComfirm,
              controller: _passwordConfimeController,
              maxLength: 16,
              decoration: const InputDecoration(
                hintText: "请再次输入密码",
                counterText: '',
                border: InputBorder.none,
              ),
              inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[\u4e00-\u9fa5]'))],
            ),
          ),
        ),
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
        const Center(
          child: Text(
            '忘记原密码?',
            style: TextStyle(
              color: ColorConst.text_gray,
              fontSize: 12,
            ),
          ),
        )
      ];
}
