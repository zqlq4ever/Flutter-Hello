import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/page/data/controller/data_home_controller.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/widgets/load_image.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';
import 'package:hello_flutter/widgets/no_scroll_behavior.dart';

/// 首页 - 数据
class DataHomePage extends StatefulWidget {
  const DataHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DataHomePage();
}

class _DataHomePage extends State<DataHomePage> with AutomaticKeepAliveClientMixin {
  late DataHomeController controller;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    controller = Get.put(DataHomeController());
    return Scaffold(
      backgroundColor: ColorConst.bg_color,
      appBar: const MyAppBar(
        backgroundColor: Colors.white,
        centerTitle: '数据',
        isBack: false,
      ),
      body: Column(
        children: [
          Gaps.vLine,
          _selectContact(context),
          Gaps.vGap16,
          _dataPart(),
        ],
      ),
    );
  }

  Container _selectContact(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 40,
      child: InkWell(
        onTap: () {
          controller.showContactListDialog();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() {
              return Text(
                controller.selectContact.value.contactName ?? DataHomeController.selecTips,
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
  }

  Expanded _dataPart() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ScrollConfiguration(
          behavior: NoScrollBehavior(),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1,
            children: _buildItems(),
          ),
        ),
      ),
    );
  }

  List<Container> _buildItems() {
    return controller.data ??= List.generate(
      controller.itemBgAssetsName.length,
      (index) => Container(
        decoration: const BoxDecoration(
          //  设置四周圆角角度
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: GestureDetector(
          onTap: () => controller.clickItem(index),
          child: LoadAssetImage(controller.itemBgAssetsName[index]),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
