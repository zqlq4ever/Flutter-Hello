import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/models/contact_history/contact_history_device_bean.dart';
import 'package:hello_flutter/models/contact_list/contact_list_item_entity.dart';
import 'package:hello_flutter/models/contact_list/contact_list_parent.dart';
import 'package:hello_flutter/page/contact/controller/contact_list_controller.dart';
import 'package:hello_flutter/page/contact/page/contact_detail_page.dart';
import 'package:hello_flutter/page/contact/page/newcontact_page.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/widgets/load_image.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';

/// 通讯录
class ContactListPage extends StatefulWidget {
  const ContactListPage({Key? key}) : super(key: key);

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  late final ContactListController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ContactListController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.bg_color,
      appBar: const MyAppBar(
        backgroundColor: Colors.white,
        centerTitle: '通讯录',
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _searchPart()),
          SliverToBoxAdapter(child: _newContact()),
          const SliverToBoxAdapter(child: Gaps.vGap16),
          SliverToBoxAdapter(child: _devicePart()),
          SliverToBoxAdapter(child: _contactPart()),
          const SliverToBoxAdapter(child: Gaps.vGap16),
        ],
      ),
    );
  }

  Widget _newContact() => InkWell(
        onTap: () => Get.to(() => const NewContactPage()),
        child: Container(
          height: 64,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Gaps.hGap16,
              ClipOval(
                child: LoadImage(
                  'https://img2.baidu.com/it/u=3004180440,146992306&fm=26&fmt=auto',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              Gaps.hGap8,
              Expanded(
                child: Text(
                  '新的朋友',
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorConst.text,
                  ),
                ),
              ),
              LoadImage(
                'ic_arrow_right',
                width: 18,
                height: 18,
              ),
              Gaps.hGap20,
            ],
          ),
        ),
      );

  ///  搜索模块
  Widget _searchPart() => Container(
        margin: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            //  搜索提示文字、图标
            ValueListenableBuilder<String>(
              valueListenable: controller.searchContent,
              builder: (context, value, child) {
                return Visibility(
                  visible: value.isEmpty,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.search_rounded,
                        size: 20,
                        color: ColorConst.text_gray,
                      ),
                      Text(
                        '请输入名字',
                        style: TextStyle(
                          color: ColorConst.text_gray,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            //  搜索框
            Container(
              color: Colors.transparent,
              child: TextField(
                cursorWidth: 3,
                maxLines: 1,
                textAlign: TextAlign.center,
                focusNode: controller.nodeSearch,
                controller: controller.searchController,
                decoration: const InputDecoration(
                  fillColor: Colors.transparent,
                  contentPadding: EdgeInsets.symmetric(horizontal: 6),
                  counterText: '',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  controller.filterByName(value);
                },
              ),
            ),
          ],
        ),
      );

  Widget _contactPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            '我的通讯录成员',
            style: TextStyle(
              color: ColorConst.text,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Obx(() => controller.isLoading.value
            ? const SizedBox.shrink()
            : _groupList()),
        Gaps.vGap16,
      ],
    );
  }

  Widget _groupList() {
    return ValueListenableBuilder<List<ContactListParent>>(
      valueListenable: controller.contactFilterData,
      builder: (context, value, child) {
        return Column(
          children: [
            for (final group in value) ...[
              Container(
                color: ColorConst.bg_color,
                padding: const EdgeInsets.only(left: 16, bottom: 8, top: 8),
                alignment: Alignment.centerLeft,
                child: Text(
                  '${group.title}',
                  style: const TextStyle(color: ColorConst.text),
                ),
              ),
              if (group.child != null)
                ...group.child!.map(_contactItem).toList(),
            ],
          ],
        );
      },
    );
  }

  Widget _contactItem(ContactListItemEntity data) => InkWell(
        onTap: () {
          Get.to(
            () => const ContactDetailPage(),
            arguments: {
              "isDevice": false,
              "name": data.contactName ?? "",
              "icon": data.contactPhoto ?? "",
              "phone": data.contactPhone ?? "",
              "group": data.type == 0 ? '其它' : '家人',
            },
          );
        },
        child: Container(
          height: 64,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gaps.hGap16,
              const ClipOval(
                child: LoadImage(
                  // data.contactPhoto ??
                  'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fup.enterdesk.com%2Fedpic%2Ff7%2F80%2F97%2Ff7809705cbe5c0fc580e401270522a0a.jpg&refer=http%3A%2F%2Fup.enterdesk.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1640836064&t=13eadc47ebd7ae973423605962f3fcd3',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              Gaps.hGap8,
              Expanded(
                child: Text(
                  data.contactName ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: ColorConst.text,
                  ),
                ),
              ),
              const LoadImage(
                'ic_arrow_right',
                width: 18,
                height: 18,
              ),
              Gaps.hGap20,
            ],
          ),
        ),
      );

  Widget _devicePart() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 0),
            child: Text(
              '我的设备',
              style: TextStyle(
                color: ColorConst.text,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Obx(
            () => controller.isLoading.value
                ? const SizedBox.shrink()
                : Column(
                    children: controller.deviceData.map(_deviceItem).toList(),
                  ),
          ),
        ],
      );

  Widget _deviceItem(ContactHistoryDeviceBean data) => InkWell(
        onTap: () {
          Get.to(
            () => const ContactDetailPage(),
            arguments: {
              "isDevice": true,
              "name": data.name ?? "",
              "icon":
                  "https://img1.baidu.com/it/u=2437536079,2390928705&fm=26&fmt=auto",
              "phone": data.simPhone ?? "",
            },
          );
        },
        child: Container(
          height: 64,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gaps.hGap16,
              const ClipOval(
                child: LoadImage(
                  'https://img1.baidu.com/it/u=2437536079,2390928705&fm=26&fmt=auto',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              Gaps.hGap8,
              Expanded(
                child: Text(
                  data.name ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: ColorConst.text,
                  ),
                ),
              ),
              const LoadImage(
                'ic_arrow_right',
                width: 18,
                height: 18,
              ),
              Gaps.hGap20,
            ],
          ),
        ),
      );
}
