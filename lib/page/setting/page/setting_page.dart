import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_flutter/models/setting/setting_menu.dart';
import 'package:hello_flutter/page/account/account_router.dart';
import 'package:hello_flutter/page/setting/setting_router.dart';
import 'package:hello_flutter/page/setting/widget/header_menu_dialog.dart';
import 'package:hello_flutter/page/setting/widget/logout_dialog.dart';
import 'package:hello_flutter/page/setting/widget/update_name_dialog.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/router/fluro_navigate_util.dart';
import 'package:hello_flutter/util/device_util.dart';
import 'package:hello_flutter/util/image_util.dart';
import 'package:hello_flutter/util/toast_util.dart';
import 'package:hello_flutter/widgets/load_image.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';
import 'package:hello_flutter/widgets/no_scroll_behavior.dart';
import 'package:image_picker/image_picker.dart';

/// 设置
class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final ImagePicker _picker = ImagePicker();
  ImageProvider? _imageProvider;
  XFile? pickedFile;
  final List<SettingMenuBean> _menuData = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.bg_color,
      appBar: MyAppBar(
        backgroundColor: Colors.white,
        centerTitle: '设置',
        onRightPressed: () {},
      ),
      body: Column(
        children: [
          Gaps.line,
          _settingBar(),
          _logoutButton(),
        ],
      ),
    );
  }

  ScrollConfiguration _settingBar() {
    return ScrollConfiguration(
        behavior: NoScrollBehavior(),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: _menuData.length,
          itemBuilder: (BuildContext context, int index) {
            return _settingItem(index, context);
          },
          separatorBuilder: (BuildContext context, int index) => Gaps.line,
        ));
  }

  /// 设置条目点击事件
  void _itemClick(int index) {
    switch (index) {
      //  头像
      case 0:
        showHeaderMenuDialog(context, (isCamera) {
          _getImage(isCamera);
        }, (headerString) {
          setState(() {
            _imageProvider = ImageUtils.getAssetImage(headerString);
          });
        });
        break;
      //  称呼
      case 1:
        showUpdateNameDialog(context, (name) {
          setState(() {
            _menuData[1].name = name;
          });
        });
        break;
      //  账号管理
      case 2:
        NavigateUtil.push(context, AccountRouter.accounthomePage);
        break;
      //  问题反馈
      case 3:
        NavigateUtil.push(context, SettingRouter.feedbackPage);
        break;
      //  关于我们
      case 4:
        NavigateUtil.push(context, SettingRouter.aboutPage);
        break;
    }
  }

  _logoutButton() => Expanded(
        child: Container(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.all(24),
          child: MaterialButton(
            minWidth: double.infinity,
            height: 44,
            color: ColorConst.app_main,
            elevation: 0,
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => showLogoutDialog(ctx),
              );
            },
            child: const Text(
              "退出登录",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );

  _settingItem(int index, BuildContext context) => Ink(
        color: Colors.white,
        height: 50,
        child: InkWell(
          onTap: () => _itemClick(index),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _menuData[index].title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: ColorConst.text,
                    ),
                  ),
                ),
              ),
              _header(index),
              Visibility(
                visible: index == 1 ? true : false,
                child: Text(
                  "${_menuData[index].name}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: ColorConst.text,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: LoadImage(
                  'ic_arrow_right',
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
        ),
      );

  _header(int index) => Visibility(
      visible: index == 0 ? true : false,
      child: CircleAvatar(
        backgroundImage: _imageProvider ??
            ImageUtils.getImageProvider(
                'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg9.51tietu.net%2Fpic%2F2019-091400%2Feebk0plequ5eebk0plequ5.jpg&refer=http%3A%2F%2Fimg9.51tietu.net&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1641007092&t=4f9c71cd56f65cb2ee2d65131e438e8d'),
        radius: 16,
        child: const SizedBox(
          width: 32,
          height: 32,
        ),
      ));

  void initData() {
    var header = SettingMenuBean('头像');
    header.photo = 'https://img0.baidu.com/it/u=3371242447,3161305562&fm=26&fmt=auto';
    var name = SettingMenuBean('称呼');
    name.name = 'Flutter';

    _menuData
      ..add(header)
      ..add(name)
      ..add(SettingMenuBean('账号管理'))
      ..add(SettingMenuBean('问题反馈'))
      ..add(SettingMenuBean('关于我们'));
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
}
