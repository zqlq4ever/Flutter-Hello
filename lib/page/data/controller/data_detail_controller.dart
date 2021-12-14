import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/models/contact_list/family_list_entity.dart';
import 'package:hello_flutter/page/data/controller/data_home_controller.dart';
import 'package:hello_flutter/page/data/widget/family_list_dialog.dart';

class DataDetailController extends GetxController with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  final PageController pageController = PageController();

  final selectName = DataHomeController.selecTips.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    selectName.value = Get.arguments['name'];
  }

  void _setSelectContact(FamilyListEntity familyListEntity) {
    selectName.value = familyListEntity.contactName ?? DataHomeController.selecTips;
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
