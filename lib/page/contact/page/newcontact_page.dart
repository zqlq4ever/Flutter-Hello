import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/models/new_contact/new_contact_entity.dart';
import 'package:hello_flutter/page/contact/controller/newcontact_controller.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/util/toast_util.dart';
import 'package:hello_flutter/widgets/load_image.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';

/// 通讯录 - 新的朋友
class NewContactPage extends GetView<NewContactlController> {
  const NewContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NewContactlController());
    return Scaffold(
      backgroundColor: ColorConst.bg_color,
      appBar: const MyAppBar(
        backgroundColor: Colors.white,
        centerTitle: '新的朋友',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Gaps.vGap16,
            _newContactList(true),
            Gaps.vGap16,
            _newContactList(false),
            Gaps.vGap16,
          ],
        ),
      ),
    );
  }

  _newContactList(bool isNewContact) => FutureBuilder(
      future: DefaultAssetBundle.of(Get.context!).loadString('assets/data/NewContactListData.json'),
      builder: (context, data) {
        //  json 解析为 List
        List result = json.decode(data.data.toString());
        List<NewContactEntity> temp =
            result.map((element) => NewContactEntity.fromJson(element)).toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: temp.length,
          itemBuilder: (context, index) => _item(isNewContact, temp[index]),
        );
      });

  _item(bool isNewContact, NewContactEntity data) => Container(
        height: 64,
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gaps.hGap16,
            ClipOval(
              child: LoadImage(
                data.headPortrait ??
                    'https://img1.baidu.com/it/u=2437536079,2390928705&fm=26&fmt=auto',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            Gaps.hGap8,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data.nickname ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: ColorConst.text,
                    ),
                  ),
                  const Text(
                    '通过手机号添加您为联系人',
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorConst.text_gray,
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: isNewContact,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      ToastUtil.show('拒绝');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      decoration: BoxDecoration(
                          border: Border.all(color: ColorConst.red),
                          borderRadius: BorderRadius.circular((14.0))),
                      alignment: Alignment.center,
                      height: 24,
                      child: const Text(
                        '拒绝',
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorConst.red,
                        ),
                      ),
                    ),
                  ),
                  Gaps.hGap8,
                  InkWell(
                    onTap: () {
                      ToastUtil.show('同意');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      decoration: BoxDecoration(
                          border: Border.all(color: ColorConst.app_main),
                          color: ColorConst.app_main,
                          borderRadius: BorderRadius.circular((14.0))),
                      alignment: Alignment.center,
                      height: 24,
                      child: const Text(
                        '同意',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: !isNewContact,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(
                    border: Border.all(color: ColorConst.text_gray),
                    color: ColorConst.text_gray,
                    borderRadius: BorderRadius.circular((14.0))),
                alignment: Alignment.center,
                height: 24,
                child: const Text(
                  '已通过',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Gaps.hGap16,
          ],
        ),
      );
}
