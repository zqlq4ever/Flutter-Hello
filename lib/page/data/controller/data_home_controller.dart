import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/models/contact_list/family_list_entity.dart';
import 'package:hello_flutter/page/data/page/data_detail_page.dart';
import 'package:hello_flutter/page/data/widget/family_list_dialog.dart';
import 'package:hello_flutter/util/log_util.dart';
import 'package:hello_flutter/util/toast_util.dart';

class DataHomeController extends GetxController {
  static const String selecTips = '选择家庭成员';

  List<Container>? data;

  final selectContact = FamilyListEntity().obs;
  final itemBgAssetsName = [
    'bg_heart_rate',
    'bg_temp',
    'bg_blood_oxygen',
  ];

  void clickItem(int itemIndex) {
    int id = selectContact.value.id ?? 0;
    if (id == 0) {
      ToastUtil.show("请先$selecTips");
      return;
    }
    String title = '';
    switch (itemIndex) {
      case 0:
        title = "血压/心率";
        break;
      case 1:
        title = "体温";
        break;
      case 2:
        title = "血氧饱和度";
        break;
    }
    Get.to(
      () => const DataDetailPage(),
      arguments: {
        "title": title,
        "name": selectContact.value.contactName ?? selecTips,
        "id": id,
      },
    );
  }

  void _setSelectContact(FamilyListEntity familyListEntity) {
    selectContact.value = familyListEntity;
  }

  void showContactListDialog() {
    DefaultAssetBundle.of(Get.context!)
        .loadString('assets/data/FamilyContactData.json')
        .then((value) {
      List result = json.decode(value);
      List<FamilyListEntity> temp =
          result.map((element) => FamilyListEntity.fromJson(element)).toList();
      showFamilyListDialog(Get.context!, temp, (contact) {
        _setSelectContact(contact);
      });
    });
  }
}
