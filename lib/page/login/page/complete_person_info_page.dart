import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/default_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';
import 'package:hello_flutter/page/home/home_router.dart';
import 'package:hello_flutter/page/login/widgets/sex_dialog.dart';
import 'package:hello_flutter/page/setting/widget/header_menu_dialog.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/constant.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/router/fluro_navigate_util.dart';
import 'package:hello_flutter/util/change_notifier_manage.dart';
import 'package:hello_flutter/util/device_util.dart';
import 'package:hello_flutter/util/image_util.dart';
import 'package:hello_flutter/util/other_util.dart';
import 'package:hello_flutter/util/toast_util.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';
import 'package:hello_flutter/widgets/my_button.dart';
import 'package:hello_flutter/widgets/my_scroll_view.dart';
import 'package:image_picker/image_picker.dart';

/// 登录 - 注册 - 完善个人信息
class CompletePersonInfoPage extends StatefulWidget {
  const CompletePersonInfoPage({Key? key}) : super(key: key);

  @override
  _CompletePersonInfoPageState createState() => _CompletePersonInfoPageState();
}

class _CompletePersonInfoPageState extends State<CompletePersonInfoPage>
    with ChangeNotifierMixin<CompletePersonInfoPage> {
  final ImagePicker _picker = ImagePicker();
  ImageProvider? _imageProvider;
  XFile? pickedFile;

  //  定义一个 controller
  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _sexController = TextEditingController(text: "");
  final TextEditingController _dateController = TextEditingController(text: "");
  final TextEditingController _passwordController = TextEditingController(text: "");
  final FocusNode _nodeName = FocusNode();
  final FocusNode _nodeSex = FocusNode();
  final FocusNode _nodeDate = FocusNode();
  final FocusNode _nodePassword = FocusNode();
  bool _clickable = false;

  @override
  Map<ChangeNotifier, List<VoidCallback>?>? changeNotifier() {
    final List<VoidCallback> callbacks = <VoidCallback>[_verify];
    return <ChangeNotifier, List<VoidCallback>?>{
      _nameController: callbacks,
      _sexController: callbacks,
      _dateController: callbacks,
      _passwordController: callbacks,
      _nodeName: null,
      _nodeSex: null,
      _nodeDate: null,
      _nodePassword: null,
    };
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
      );
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nodeName.dispose();
    _nodeSex.dispose();
    _nodeDate.dispose();
    _nodePassword.dispose();
  }

  void _verify() {
    final String name = _nameController.text;
    final String sex = _sexController.text;
    final String date = _dateController.text;
    final String password = _passwordController.text;
    bool clickable = true;
    if (name.isEmpty || name.length < 11) {
      clickable = false;
    }
    if (sex.isEmpty) {
      clickable = false;
    }
    if (date.isEmpty) {
      clickable = false;
    }
    if (password.isEmpty || password.length < 6) {
      clickable = false;
    }

    /// 状态不一样再刷新，避免不必要的 setState
    if (clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }

  void _completePersonInfo() {
    SpUtil.putBool(AppConstant.hasLogin, true);
    NavigateUtil.push(context, HomeRouter.homePage, clearStack: true);
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return Scaffold(
      appBar: MyAppBar(
        backgroundColor: Colors.white,
        isBack: true,
        centerTitle: '完善个人资料',
      ),
      body: MyScrollView(
        keyboardConfig: Util.getKeyboardActionsConfig(
          context,
          <FocusNode>[
            _nodeName,
            _nodeSex,
            _nodeDate,
            _nodePassword,
          ],
        ),
        children: _buildBody,
      ),
    );
  }

  Future<void> _getImage(bool isCamera) async {
    try {
      pickedFile = await _picker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 800,
      );
      if (pickedFile != null) {
        if (DeviceUtil.isWeb) {
          _imageProvider = NetworkImage(pickedFile!.path);
        } else {
          _imageProvider = FileImage(File(pickedFile!.path));
        }
      } else {
        _imageProvider = null;
      }
      setState(() {});
    } catch (e) {
      if (e is MissingPluginException) {
        ToastUtil.show('当前平台暂不支持！');
      } else {
        ToastUtil.show('没有权限，无法打开相册！');
      }
    }
  }

  get _buildBody => <Widget>[
        header(),
        Gaps.vGap16,
        name(),
        sex(),
        date(),
        password(),
        Gaps.vGap40,
        registerAndLogin(),
      ];

  Container registerAndLogin() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: MyButton(
        key: const Key('completePersonInfo'),
        onPressed: _clickable ? _completePersonInfo : null,
        text: '注册并登录',
        radius: 24,
      ),
    );
  }

  Center header() {
    return Center(
      heightFactor: 2,
      child: GestureDetector(
        child: ClipOval(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _imageProvider ??
                    ImageUtils.getImageProvider(
                        'https://img0.baidu.com/it/u=1276302017,1487256346&fm=26&fmt=auto'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        onTap: () {
          HeaderMenuDialog(
            context,
            (isCamera) {
              _getImage(isCamera);
            },
            (headerString) {
              setState(() {
                _imageProvider = ImageUtils.getAssetImage(headerString);
              });
            },
          );
        },
      ),
    );
  }

  //隐藏键盘而不丢失文本字段焦点：
  void hideKeyBoard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  Container password() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Center(
        child: TextField(
          maxLines: 1,
          maxLength: 20,
          focusNode: _nodePassword,
          controller: _passwordController,
          decoration: InputDecoration(
            hintStyle: TextStyle(color: ColorConst.text_gray),
            hintText: "请输入密码",
            counterText: '',
            border: InputBorder.none,
          ),
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[\u4e00-\u9fa5]'))],
        ),
      ),
    );
  }

  Container name() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Center(
        child: TextField(
          maxLines: 1,
          maxLength: 20,
          focusNode: _nodeName,
          controller: _nameController,
          decoration: InputDecoration(
            hintStyle: TextStyle(color: ColorConst.text_gray),
            hintText: "请输入昵称",
            counterText: '',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Container sex() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              enabled: false,
              focusNode: _nodeSex,
              controller: _sexController,
              decoration: InputDecoration(
                hintText: "请选择性别",
                hintStyle: TextStyle(color: ColorConst.text_gray),
                counterText: '',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              _nodeName.unfocus();
              _nodePassword.unfocus();
              SexSelectDialog(context, (sex) {
                _sexController.text = sex;
              });
            },
            icon: Icon(
              Icons.arrow_drop_down_rounded,
              color: ColorConst.text,
            ),
          ),
        ],
      ),
    );
  }

  Container date() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              enabled: false,
              focusNode: _nodeDate,
              controller: _dateController,
              decoration: InputDecoration(
                hintText: "请选择出生年月",
                hintStyle: TextStyle(color: ColorConst.text_gray),
                counterText: '',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              _nodeName.unfocus();
              _nodePassword.unfocus();
              _datePicker();
            },
            icon: Icon(
              Icons.arrow_drop_down_rounded,
              color: ColorConst.text,
            ),
          ),
        ],
      ),
    );
  }

  void _datePicker() {
    DateTime date = DateTime.now();
    Pickers.showDatePicker(
      context,
      mode: DateMode.YMD,
      suffix: Suffix.normal(),
      pickerStyle: DefaultPickerStyle(haveRadius: true, title: '出生日期'),
      minDate: PDuration(year: 1960, month: 1, day: 1),
      maxDate: PDuration(year: date.year, month: date.month, day: date.day),
      onConfirm: (p) {
        print('longer >>> 返回数据：$p');
        _dateController.text = '${p.year}/${p.month}/${p.day}';
      },
    );
  }
}
