import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/page/data/controller/data_detail_controller.dart';
import 'package:hello_flutter/page/data/page/data_chart_page.dart';
import 'package:hello_flutter/page/data/page/data_single_page.dart';
import 'package:hello_flutter/page/data/page/measure_notice_page.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/widgets/keep_alive_wrapper.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';

/// 数据 - 数据图表
class DataDetailPage extends GetView<DataDetailController> {
  const DataDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DataDetailController());
    return Scaffold(
      backgroundColor: ColorConst.bg_color,
      appBar: MyAppBar(
        backgroundColor: Colors.white,
        centerTitle: Get.arguments['title'],
        rightText: '说明',
        onRightPressed: () => Get.to(() => const MeasureNoticePage()),
      ),
      body: Column(
        children: [
          Gaps.vLine,
          _selectContact(context),
          Gaps.vGap16,
          _tabBar(),
          Expanded(
            child: PageView(
              children: const [
                KeepAliveWrapper(child: DataSinglePage()),
                KeepAliveWrapper(child: DataChartPage()),
              ],
              onPageChanged: (index) => controller.tabController?.animateTo(index),
              controller: controller.pageController,
            ),
          ),
        ],
      ),
    );
  }

  Container _selectContact(BuildContext context) => Container(
        color: Colors.white,
        height: 40,
        child: InkWell(
          onTap: () => controller.showContactListDialog(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                return Text(
                  controller.selectName.value,
                  style: const TextStyle(
                    color: ColorConst.text,
                    fontSize: 14,
                  ),
                );
              }),
              const Icon(
                Icons.arrow_drop_down,
                size: 18,
              ),
            ],
          ),
        ),
      );

  _tabBar() => Center(
        //  套一层 Theme ,去掉 Tab 按下时的水波纹效果
        child: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: TabBar(
            onTap: (index) {
              controller.pageController.jumpToPage(index);
            },
            labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 14),
            isScrollable: true,
            controller: controller.tabController,
            labelColor: ColorConst.app_main,
            indicatorWeight: 3,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
            unselectedLabelColor: ColorConst.text,
            indicatorColor: ColorConst.app_main,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(text: "测量信息"),
              Tab(text: "图表信息"),
            ],
          ),
        ),
      );
}
