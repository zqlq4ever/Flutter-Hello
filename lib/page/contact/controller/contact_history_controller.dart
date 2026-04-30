import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/models/contact_history/contact_history_device_bean.dart';
import 'package:hello_flutter/models/contact_history/contact_history_latest_bean.dart';

class ContactHistoryController extends GetxController {
  final RxList<ContactHistoryLatestBean> latestList =
      <ContactHistoryLatestBean>[].obs;
  final RxList<ContactHistoryDeviceBean> deviceList =
      <ContactHistoryDeviceBean>[].obs;

  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      isLoading.value = true;
      final latestJson = await rootBundle
          .loadString('assets/data/ContactHistoryLatestData.json');
      final deviceJson = await rootBundle
          .loadString('assets/data/ContactHistoryDeviceListData.json');

      final latestDecoded = json.decode(latestJson) as List;
      final deviceDecoded = json.decode(deviceJson) as List;

      latestList.assignAll(
        latestDecoded.map((e) => ContactHistoryLatestBean.fromJson(e)).toList(),
      );
      deviceList.assignAll(
        deviceDecoded.map((e) => ContactHistoryDeviceBean.fromJson(e)).toList(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
