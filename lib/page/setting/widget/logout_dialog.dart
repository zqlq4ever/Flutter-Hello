import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/page/login/login_router.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/constant.dart';
import 'package:hello_flutter/router/fluro_navigate_util.dart';

Widget LogoutDialog(BuildContext context) {
  return Material(
    color: Colors.transparent,
    child: CupertinoAlertDialog(
        title: _buildTitle(context),
        content: _buildContent(),
        actions: <Widget>[
          CupertinoButton(
            child: Text(
              "取消",
              style: TextStyle(
                color: ColorConst.text,
                fontSize: 18,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoButton(
            child: Text(
              "退出",
              style: TextStyle(
                color: ColorConst.app_main,
                fontSize: 18,
              ),
            ),
            onPressed: () {
              SpUtil.putBool(AppConstant.hasLogin, false);
              Navigator.pop(context);
              NavigateUtil.push(context, LoginRouter.loginPage, clearStack: true);
            },
          ),
        ]),
  );
}

Widget _buildTitle(context) {
  return Container(
    alignment: Alignment.center,
    child: Text(
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
      child: Text(
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
