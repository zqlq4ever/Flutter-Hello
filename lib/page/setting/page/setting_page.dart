import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/page/account/page/account_home_page.dart';
import 'package:hello_flutter/page/setting/controller/setting_controller.dart';
import 'package:hello_flutter/page/setting/page/about_page.dart';
import 'package:hello_flutter/page/setting/widget/header_menu_dialog.dart';
import 'package:hello_flutter/page/setting/widget/logout_dialog.dart';
import 'package:hello_flutter/page/setting/widget/update_name_dialog.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/util/image_util.dart';
import 'package:hello_flutter/util/log_util.dart';
import 'package:hello_flutter/widgets/load_image.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';
import 'package:hello_flutter/widgets/no_scroll_behavior.dart';

import 'feedback_page.dart';

/// 设置
class SettingPage extends GetView<SettingController> {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SettingController());
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
        child: Obx(() {
          return ListView.separated(
            shrinkWrap: true,
            itemCount: controller.menuData.length,
            itemBuilder: (BuildContext context, int index) {
              return _settingItem(index, context);
            },
            separatorBuilder: (BuildContext context, int index) => Gaps.line,
          );
        }));
  }

  /// 设置条目点击事件
  void _itemClick(int index) {
    switch (index) {
      //  头像
      case 0:
        showHeaderMenuDialog(
          Get.context!,
          (isCamera) {
            controller.getImage(isCamera);
          },
          (headerAssetsName) {
            Logger.d('-------------' + headerAssetsName);
            if ("return" == headerAssetsName) return;

            controller.menuData[0] = controller.menuData[0]
              ..photo = ImageUtils.getAssetImage(headerAssetsName);
          },
        );
        break;
      //  称呼
      case 1:
        showUpdateNameDialog(
          Get.context!,
          controller.nameController,
          (name) {
            controller.menuData[1] = controller.menuData[1]..name = name;
          },
        );
        break;
      //  账号管理
      case 2:
        Get.to(() => const AccountHomePage());
        break;
      //  问题反馈
      case 3:
        Get.to(() => const FeedbackPage());
        break;
      //  关于我们
      case 4:
        Get.to(() => const AboutPage());
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
                context: Get.context!,
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

  _header(int index) => Visibility(
        visible: index == 0 ? true : false,
        child: CircleAvatar(
          backgroundImage: controller.menuData[0].photo,
          radius: 16,
          child: const SizedBox(
            width: 32,
            height: 32,
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
                    controller.menuData[index].title,
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
                  "${controller.menuData[index].name}",
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
}
