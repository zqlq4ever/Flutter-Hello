import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/page/account/controller/account_home_controller.dart';
import 'package:hello_flutter/page/account/page/update_password_page.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/widgets/load_image.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';

/// 我的家 - 设置 - 账号管理
class AccountHomePage extends GetView<AccountHomeController> {
  const AccountHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AccountHomeController());
    return Scaffold(
      backgroundColor: ColorConst.bg_color,
      appBar: const MyAppBar(
        backgroundColor: Colors.white,
        centerTitle: '账号管理',
      ),
      body: Column(
        children: [
          Gaps.vLine,
          _item('微信', '去绑定', () {}),
          Gaps.vLine,
          _item('手机号', '12355556666', () {}),
          Gaps.vLine,
          _item('修改密码', '', () => Get.to(() => const UpdatePasswordPage())),
        ],
      ),
    );
  }

  _item(String title, String value, Function click) => InkWell(
        onTap: () => click(),
        child: Container(
          height: 50,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gaps.hGap16,
              Text(
                title,
                style: const TextStyle(
                  color: ColorConst.text,
                  fontSize: 16,
                ),
              ),
              Gaps.hGap8,
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 16,
                    color: ColorConst.text_gray,
                  ),
                ),
              ),
              Gaps.hGap8,
              const LoadImage(
                'ic_arrow_right',
                width: 20,
                height: 20,
              ),
              Gaps.hGap16,
            ],
          ),
        ),
      );
}
