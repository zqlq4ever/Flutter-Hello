import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/models/contact_history/contact_history_device_bean.dart';
import 'package:hello_flutter/models/contact_list/contact_list_item_entity.dart';
import 'package:hello_flutter/models/contact_list/contact_list_parent.dart';
import 'package:hello_flutter/util/log_util.dart';
import 'package:lpinyin/lpinyin.dart';

class ContactListController extends GetxController {
  //  设备列表
  List<ContactHistoryDeviceBean> deviceData = [];

  //  原始数据
  List<ContactListItemEntity> contactSourceData = [];

  //  输入框内容监听
  final ValueNotifier<String> searchContent = ValueNotifier<String>('');

  //  筛选数据
  final ValueNotifier<List<ContactListParent>> contactFilterData =
      ValueNotifier<List<ContactListParent>>([]);

  //  输入框文本
  final TextEditingController searchController =
      TextEditingController(text: '');

  //  输入框焦点
  final FocusNode nodeSearch = FocusNode();

  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      isLoading.value = true;
      final deviceJson =
          await rootBundle.loadString('assets/data/ContactDeviceListData.json');
      final contactJson =
          await rootBundle.loadString('assets/data/ContactListData.json');

      final deviceDecoded = json.decode(deviceJson) as List;
      final contactDecoded = json.decode(contactJson) as List;

      deviceData = deviceDecoded
          .map((e) => ContactHistoryDeviceBean.fromJson(e))
          .toList();
      contactSourceData =
          contactDecoded.map((e) => ContactListItemEntity.fromJson(e)).toList();
      groupSourceData(contactSourceData);
    } finally {
      isLoading.value = false;
    }
  }

  void filterByName(String value) {
    searchContent.value = value;
    if (value.isEmpty) {
      groupSourceData(contactSourceData);
      return;
    }
    final temp = <ContactListItemEntity>[];
    for (final element in contactSourceData) {
      final name = element.contactName;
      if (name != null && name.contains(value)) {
        temp.add(element);
      }
    }
    groupSourceData(temp);
  }

  @override
  void onClose() {
    searchController.dispose();
    nodeSearch.dispose();
    searchContent.dispose();
    contactFilterData.dispose();
    super.onClose();
  }

  void groupSourceData(List<ContactListItemEntity> data) {
    var map = <String, List<ContactListItemEntity>>{};
    for (var contact in data) {
      contact.contactPhoto =
          'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fup.enterdesk.com%2Fedpic_source%2F53%2F0a%2Fda%2F530adad966630fce548cd408237ff200.jpg&refer=http%3A%2F%2Fup.enterdesk.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1641349181&t=4b9a02287d7062cde79ef52d05e3025c';
      if (contact.standbyState1 == 1) {
        continue;
      }
      String pinyin = PinyinHelper.getFirstWordPinyin(contact.contactName ?? '')
          .substring(0, 1);
      if (map.keys.contains(pinyin)) {
        List<ContactListItemEntity>? list = map[pinyin];
        if (list == null || list.isEmpty) {
          list = [];
          list.add(contact);
        } else if (!list.contains(contact)) {
          list.add(contact);
        }
      } else {
        map.putIfAbsent(pinyin, () => [contact]);
      }
    }

    Logger.d('--------------------');

    //  按名字分类后的数据
    List<ContactListParent> temp = [];
    for (var pinyin in map.keys) {
      ContactListParent parent = ContactListParent();
      parent.title = pinyin;
      parent.child = map[pinyin];
      temp.add(parent);
    }
    contactFilterData.value = temp;
  }
}
