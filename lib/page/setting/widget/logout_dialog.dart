import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/page/login/page/login_page.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/constant.dart';

Widget showLogoutDialog(BuildContext context) {
  return Material(
    color: Colors.transparent,
    child: CupertinoAlertDialog(
        title: _buildTitle(context),
        content: _buildContent(),
        actions: <Widget>[
          CupertinoButton(
            child: const Text(
              "取消",
              style: TextStyle(
                color: ColorConst.text,
                fontSize: 18,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoButton(
            child: const Text(
              "退出",
              style: TextStyle(
                color: ColorConst.app_main,
                fontSize: 18,
              ),
            ),
            onPressed: () {
              SpUtil.putBool(AppConstant.hasLogin, false);
              Navigator.pop(context);
              Get.offAll(() => const LoginPage());
            },
          ),
        ]),
  );
}

Widget _buildTitle(context) {
  return Container(
    alignment: Alignment.center,
    child: const Text(
      '退出登录',
      style: TextStyle(
        color: ColorConst.text,
        fontSize: 20,
      ),
    ),
  );
}

Widget _buildContent() {
  return Padding(
    padding: const EdgeInsets.only(top: 18.0),
    child: Container(
      alignment: Alignment.center,
      child: const Text(
        '确定退出登录吗?',
        style: TextStyle(
          color: ColorConst.text,
          fontSize: 16,
        ),
        textAlign: TextAlign.justify,
      ),
    ),
  );
}
