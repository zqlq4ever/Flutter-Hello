import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/page/login/controller/default_header_controller.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/widgets/load_image.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';
import 'package:hello_flutter/widgets/no_scroll_behavior.dart';

/// 登录 - 注册 - 完善个人信息 - 默认头像
class DefautHeaderPage extends GetView<DefaultHeaderController> {
  const DefautHeaderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DefaultHeaderController());
    return Scaffold(
      appBar: const MyAppBar(
        isBack: true,
        centerTitle: '选择头像',
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: ColorConst.bg_color,
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Gaps.vGap24,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: _headerList,
            ),
            Gaps.vGap50,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: MaterialButton(
                minWidth: double.infinity,
                height: 44,
                color: ColorConst.app_main,
                splashColor: Colors.transparent,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ),
                ),
                child: const Text(
                  "确定",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  Get.back(result: controller.data[controller.selectedIndex.value]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  get _headerList => ScrollConfiguration(
        behavior: NoScrollBehavior(),
        child: GridView.builder(
            shrinkWrap: true,
            itemCount: controller.data.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //  横轴元素个数
                crossAxisCount: 3,
                //  纵轴间距
                mainAxisSpacing: 25.0,
                //  横轴间距
                crossAxisSpacing: 32.0,
                //  子组件宽高长度比例
                childAspectRatio: 1.0),
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                children: [
                  Obx(() {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: controller.selectedIndex.value == index
                              ? ColorConst.app_main
                              : Colors.transparent,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(300),
                      ),
                      child: GestureDetector(
                        onTap: () => controller.setSelectIndex(index),
                        child: LoadAssetImage(controller.data[index]),
                      ),
                    );
                  }),
                  Obx(
                    () => Visibility(
                      visible: controller.selectedIndex.value == index,
                      child: const Positioned(
                        right: 10,
                        child: LoadAssetImage(
                          'ic_selected',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
      );
}
