import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/page/contact/page/contact_history_page.dart';
import 'package:hello_flutter/page/data/page/data_home_page.dart';
import 'package:hello_flutter/page/myhome/page/my_home_page.dart';

class HomeController extends GetxController {
  final PageController pageController = PageController();
  final currentIndex = 0.obs;
  late List<Widget> pageList;
  final List<String> appBarTitles = ['我的家', '通讯', '数据'];
  List<BottomNavigationBarItem>? list;

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  @override
  void onReady() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
      );
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void setCurrentIndex(int index) {
    currentIndex.value = index;
  }

  void initData() {
    pageList = [
      const MyHomePage(),
      const ContactHistoryPage(),
      const DataHomePage(),
    ];
  }
}
