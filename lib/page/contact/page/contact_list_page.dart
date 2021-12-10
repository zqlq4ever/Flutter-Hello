import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
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
import 'package:sticky_headers/sticky_headers/widget.dart';

/// 通讯录
class ContactListPage extends GetView<ContactListController> {
  const ContactListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ContactListController());
    return Scaffold(
        backgroundColor: ColorConst.bg_color,
        appBar: const MyAppBar(
          backgroundColor: Colors.white,
          centerTitle: '通讯录',
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _searchPart(),
              _newContact(),
              Gaps.vGap16,
              _list(),
            ],
          ),
        ));
  }

  _list() => Expanded(
        child: NestedScrollView(
          body: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) => _devicePart(),
                  childCount: 1,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) => _contactPart(),
                  childCount: 1,
                ),
              ),
            ],
          ),
          headerSliverBuilder: (
            BuildContext context,
            bool innerBoxIsScrolled,
          ) {
            return [];
          },
        ),
      );

  _stickyChildList(List<ContactListItemEntity> data) => ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _contactItem(data[index]);
      });

  _newContact() => InkWell(
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
  _searchPart() => Container(
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
                  controller.searchContent.value = value;
                  //  数据筛选
                  List<ContactListItemEntity> temp = [];
                  if (value.isEmpty) {
                    temp = controller.contactSourceData;
                  } else {
                    for (var element in controller.contactSourceData) {
                      if (element.contactName != null &&
                          value.isNotEmpty &&
                          element.contactName!.contains(value)) {
                        temp.add(element);
                        print(element);
                      }
                    }
                  }
                  controller.groupSourceData(temp);
                },
              ),
            ),
          ],
        ),
      );

  _contactPart() {
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
        _sticky(),
        Gaps.vGap16,
      ],
    );
  }

  _deviceList() => FutureBuilder(
      future:
          DefaultAssetBundle.of(Get.context!).loadString('assets/data/ContactDeviceListData.json'),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        }
        //  json 解析为 List
        List result = json.decode(snapshot.data.toString());
        //  List 元素转为具体对象
        controller.deviceData =
            result.map((element) => ContactHistoryDeviceBean.fromJson(element)).toList();
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.deviceData.length,
          itemBuilder: (context, index) => _deviceItem(controller.deviceData[index]),
        );
      });

  _sticky() => FutureBuilder(
        future: DefaultAssetBundle.of(Get.context!).loadString('assets/data/ContactListData.json'),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container();
          }
          //  json 解析为 List
          List result = json.decode(snapshot.data.toString());
          //  List 元素转为具体对象
          controller.contactSourceData =
              result.map((element) => ContactListItemEntity.fromJson(element)).toList();
          //  对原始数据进行分类
          controller.groupSourceData(controller.contactSourceData);

          return ValueListenableBuilder<List<ContactListParent>>(
            valueListenable: controller.contactFilterData,
            builder: (context, value, child) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.length,
                itemBuilder: (context, index) => StickyHeader(
                  header: Container(
                    color: ColorConst.bg_color,
                    padding: const EdgeInsets.only(left: 16, bottom: 8, top: 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${value[index].title}',
                      style: const TextStyle(color: ColorConst.text),
                    ),
                  ),
                  content: _stickyChildList(controller.contactFilterData.value[index].child!),
                ),
              );
            },
          );
        },
      );

  _contactItem(ContactListItemEntity data) => InkWell(
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

  _devicePart() => Column(
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
          _deviceList()
        ],
      );

  _deviceItem(ContactHistoryDeviceBean data) => InkWell(
        onTap: () {
          Get.to(
            () => const ContactDetailPage(),
            arguments: {
              "isDevice": true,
              "name": data.name ?? "",
              "icon": "https://img1.baidu.com/it/u=2437536079,2390928705&fm=26&fmt=auto",
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
