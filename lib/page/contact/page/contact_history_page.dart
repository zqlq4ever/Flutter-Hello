import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/models/contact_history/contact_history_device_bean.dart';
import 'package:hello_flutter/models/contact_history/contact_history_latest_bean.dart';
import 'package:hello_flutter/page/contact/controller/contact_history_controller.dart';
import 'package:hello_flutter/page/contact/page/contact_list_page.dart';
import 'package:hello_flutter/page/contact/widget/call_menu_dialog.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/util/other_util.dart';
import 'package:hello_flutter/widgets/load_image.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';

/// 首页 - 通讯
class ContactHistoryPage extends StatefulWidget {
  const ContactHistoryPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ContactHistoryPage();
}

class _ContactHistoryPage extends State<ContactHistoryPage>
    with AutomaticKeepAliveClientMixin {
  late ContactHistoryController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ContactHistoryController());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: ColorConst.bg_color,
        appBar: MyAppBar(
          backgroundColor: Colors.white,
          centerTitle: '通讯',
          rightText: '通讯录',
          isBack: false,
          onRightPressed: () => Get.to(() => const ContactListPage()),
        ),
        body: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: Gaps.vGap16),
            SliverToBoxAdapter(child: devicePart()),
            const SliverToBoxAdapter(child: Gaps.vGap16),
            SliverToBoxAdapter(child: latestPart()),
            const SliverToBoxAdapter(child: Gaps.vGap8),
          ],
        ));
  }

  Card latestPart() => Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '最近联系',
                style: TextStyle(
                  color: ColorConst.text,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Obx(() => _latestList(controller.latestList)),
            Gaps.vGap16,
          ],
        ),
      );

  Widget _latestList(List<ContactHistoryLatestBean> data) {
    if (controller.isLoading.value) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (int i = 0; i < data.length; i++) ...[
            _latestItem(data[i]),
            if (i != data.length - 1) Gaps.vGap12,
          ],
        ],
      ),
    );
  }

  Widget _latestItem(ContactHistoryLatestBean bean) => Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: LoadImage(
                  bean.contactPhoto ??
                      'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F202001%2F27%2F20200127073345_ixcrq.png&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1640414104&t=b2be48dcfae2dc885e9efaaac0831ac2',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              Gaps.hGap8,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bean.contactName ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: ColorConst.text,
                    ),
                  ),
                  Text(
                    bean.createTime ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: ColorConst.text_gray,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: InkWell(
                  onTap: () => showCallMenuDialog(context, (index) {
                    switch (index) {
                      //  视频
                      case 1:
                        break;
                      //  语音
                      case 2:
                        break;
                      //  电话
                      case 3:
                        Util.launchTelURL(bean.phone ?? '');
                        break;
                    }
                  }),
                  child: const LoadImage(
                    'ic_call',
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  devicePart() => Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '设备通话',
                style: TextStyle(
                  color: ColorConst.text,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Obx(() => _deviceList(controller.deviceList)),
            Gaps.vGap16,
          ],
        ),
      );

  Widget _deviceList(List<ContactHistoryDeviceBean> data) {
    if (controller.isLoading.value) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (int i = 0; i < data.length; i++) ...[
            _deviceItem(data[i]),
            if (i != data.length - 1) Gaps.vGap12,
          ],
        ],
      ),
    );
  }

  Widget _deviceItem(ContactHistoryDeviceBean bean) => Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ClipOval(
                child: LoadImage(
                  'https://img0.baidu.com/it/u=1544923211,727191905&fm=15&fmt=auto',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              Gaps.hGap8,
              Text(
                bean.deviceNickname ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  color: ColorConst.text,
                ),
              ),
              Visibility(
                visible: bean.isDfDevice == 1,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: ColorConst.app_main_55,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  child: const Text(
                    '默认',
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorConst.app_main,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: InkWell(
                  onTap: () => showCallMenuDialog(context, (index) {
                    switch (index) {
                      case 1:
                        break;
                      case 2:
                        break;
                      case 3:
                        Util.launchTelURL(bean.simPhone ?? '');
                        break;
                    }
                  }),
                  child: const LoadImage(
                    'ic_call',
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  @override
  bool get wantKeepAlive => true;
}
