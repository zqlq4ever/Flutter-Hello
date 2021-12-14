import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/default_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/page/login/controller/complete_info_controller.dart';
import 'package:hello_flutter/page/login/widgets/sex_dialog.dart';
import 'package:hello_flutter/page/setting/widget/header_menu_dialog.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/util/focus_util.dart';
import 'package:hello_flutter/util/image_util.dart';
import 'package:hello_flutter/util/log_util.dart';
import 'package:hello_flutter/util/other_util.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';
import 'package:hello_flutter/widgets/my_button.dart';
import 'package:hello_flutter/widgets/my_scroll_view.dart';

/// 登录 - 注册 - 完善个人信息
class CompletePersonInfoPage extends GetView<CompleteInfoController> {
  const CompletePersonInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CompleteInfoController());
    YYDialog.init(context);
    return Scaffold(
      appBar: const MyAppBar(
        backgroundColor: Colors.white,
        isBack: true,
        centerTitle: '完善个人资料',
      ),
      body: MyScrollView(
        keyboardConfig: Util.getKeyboardActionsConfig(context, []),
        children: _buildBody,
      ),
    );
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
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Obx(() {
        return MyButton(
          key: const Key('completePersonInfo'),
          onPressed: controller.clickable.value ? controller.completePersonInfo : null,
          text: '注册并登录',
          radius: 24,
        );
      }),
    );
  }

  Center header() {
    return Center(
      heightFactor: 2,
      child: InkWell(
        child: Obx(() {
          return CircleAvatar(
            backgroundImage: controller.selectImage[0],
            backgroundColor: Colors.white,
            radius: 40,
            child: const SizedBox(
              width: 80,
              height: 80,
            ),
          );
        }),
        onTap: () {
          Logger.d(controller.selectImage.toString());
          FocusUtil.unfocus();
          showHeaderMenuDialog(
            Get.context!,
            (isCamera) {
              controller.getImage(isCamera);
            },
            (headerString) {
              Logger.d('-------------' + headerString);
              if ("return" == headerString) return;
              controller.selectImage.value = [ImageUtils.getAssetImage(headerString)];
            },
          );
        },
      ),
    );
  }

  Container password() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Center(
        child: TextField(
          maxLines: 1,
          maxLength: 20,
          controller: controller.passwordController,
          decoration: const InputDecoration(
            hintStyle: TextStyle(color: ColorConst.text_gray),
            hintText: "请输入密码",
            counterText: '',
            border: InputBorder.none,
          ),
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[\u4e00-\u9fa5]'))],
          onChanged: (value) => controller.verify(),
        ),
      ),
    );
  }

  Container name() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Center(
        child: TextField(
          maxLines: 1,
          maxLength: 20,
          controller: controller.nameController,
          decoration: const InputDecoration(
            hintStyle: TextStyle(color: ColorConst.text_gray),
            hintText: "请输入昵称",
            counterText: '',
            border: InputBorder.none,
          ),
          onChanged: (value) => controller.verify(),
        ),
      ),
    );
  }

  Container sex() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              enabled: false,
              controller: controller.sexController,
              decoration: const InputDecoration(
                hintText: "请选择性别",
                hintStyle: TextStyle(color: ColorConst.text_gray),
                counterText: '',
                border: InputBorder.none,
              ),
              onChanged: (value) => controller.verify(),
            ),
          ),
          IconButton(
            onPressed: () {
              showSexSelectDialog(Get.context!, (sex) {
                controller.sexController.text = sex;
              });
            },
            icon: const Icon(
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
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              enabled: false,
              controller: controller.dateController,
              decoration: const InputDecoration(
                hintText: "请选择出生年月",
                hintStyle: TextStyle(color: ColorConst.text_gray),
                counterText: '',
                border: InputBorder.none,
              ),
              onChanged: (value) => controller.verify(),
            ),
          ),
          IconButton(
            onPressed: () {
              _datePicker();
            },
            icon: const Icon(
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
      Get.context!,
      mode: DateMode.YMD,
      suffix: Suffix.normal(),
      pickerStyle: DefaultPickerStyle(haveRadius: true, title: '出生日期'),
      minDate: PDuration(year: 1960, month: 1, day: 1),
      maxDate: PDuration(year: date.year, month: date.month, day: date.day),
      onConfirm: (result) {
        Logger.d('longer >>> 返回数据：$result');
        controller.dateController.text = '${result.year}/${result.month}/${result.day}';
      },
    );
  }
}
