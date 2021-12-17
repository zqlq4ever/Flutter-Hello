import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/page/home/controller/home_controller.dart';
import 'package:hello_flutter/res/resources.dart';
import 'package:hello_flutter/widgets/double_tap_back_exit_app.dart';
import 'package:hello_flutter/widgets/load_image.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return DoubleTapBackExitApp(
      child: Scaffold(
        body: PageView(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (int index) => controller.setCurrentIndex(index),
          children: controller.pageList,
        ),
        bottomNavigationBar: Obx(() {
          return BottomNavigationBar(
            items: _bottomNavigationBarItem(),
            currentIndex: controller.currentIndex.value,
            type: BottomNavigationBarType.fixed,
            elevation: 5.0,
            iconSize: 21.0,
            selectedFontSize: 10,
            unselectedFontSize: 10,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: ColorConst.unselected_item_color,
            onTap: (index) => controller.pageController.jumpToPage(index),
          );
        }),
      ),
    );
  }

  /// 底部 tab 标签
  List<BottomNavigationBarItem> _bottomNavigationBarItem() {
    if (controller.list == null) {
      const double _imageSize = 25.0;
      const _tabImages = [
        [
          LoadAssetImage('ic_home', width: _imageSize, color: ColorConst.unselected_item_color),
          LoadAssetImage('ic_home', width: _imageSize, color: ColorConst.app_main)
        ],
        [
          LoadAssetImage('ic_contact', width: _imageSize, color: ColorConst.unselected_item_color),
          LoadAssetImage('ic_contact', width: _imageSize, color: ColorConst.app_main)
        ],
        [
          LoadAssetImage('ic_data', width: _imageSize, color: ColorConst.unselected_item_color),
          LoadAssetImage('ic_data', width: _imageSize, color: ColorConst.app_main)
        ],
      ];
      controller.list = List.generate(
        _tabImages.length,
        (index) => BottomNavigationBarItem(
          icon: _tabImages[index][0],
          activeIcon: _tabImages[index][1],
          label: controller.appBarTitles[index],
        ),
      );
    }
    return controller.list!;
  }
}
