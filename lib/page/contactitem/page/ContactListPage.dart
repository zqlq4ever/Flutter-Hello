import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/models/contact_history/contact_history_device_bean.dart';
import 'package:hello_flutter/models/contact_list/contact_list_item_entity.dart';
import 'package:hello_flutter/models/contact_list/contact_list_parent.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/router/fluro_navigate_util.dart';
import 'package:hello_flutter/widgets/load_image.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../contact_router.dart';

/// 通讯录
class ContactListPage extends StatefulWidget {
  const ContactListPage({Key? key}) : super(key: key);

  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  //  设备列表
  List<ContactHistoryDeviceBean> _deviceData = [];

  //  原始数据
  List<ContactListItemEntity> _contactSourceData = [];

  //  输入框内容监听
  ValueNotifier<String> _searchContent = ValueNotifier<String>('');

  //  筛选数据
  ValueNotifier<List<ContactListParent>> _contactFilterData =
      ValueNotifier<List<ContactListParent>>([]);

  //  输入框文本
  final TextEditingController _searchController = TextEditingController(text: "");

  //  输入框焦点
  final FocusNode _nodeSearch = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConst.bg_color,
        appBar: MyAppBar(
          backgroundColor: Colors.white,
          centerTitle: '通讯录',
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
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

  _sticky() => FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString('assets/data/ContactListData.json'),
        builder: (context, data) {
          //  json 解析为 List
          List result = json.decode(data.data.toString());
          //  List 元素转为具体对象
          _contactSourceData =
              result.map((element) => ContactListItemEntity.fromJson(element)).toList();
          //  对原始数据进行分类
          _groupSourceData(_contactSourceData);

          return ValueListenableBuilder<List<ContactListParent>>(
            valueListenable: _contactFilterData,
            builder: (context, value, child) {
              return Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: value.length,
                  itemBuilder: (context, index) => Container(
                    child: StickyHeader(
                      header: Container(
                        color: ColorConst.bg_color,
                        padding: EdgeInsets.only(left: 16, bottom: 8, top: 8),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${value[index].title}',
                          style: TextStyle(color: ColorConst.text),
                        ),
                      ),
                      content: InkWell(
                        onTap: () {
                          print("content");
                        },
                        child: _stickyChildList(value[index].child!),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );

  void _groupSourceData(List<ContactListItemEntity> data) {
    //  按名字分类后的数据
    List<ContactListParent> temp = [];
    var map = Map<String, List<ContactListItemEntity>>();
    data.forEach((contact) {
      contact.contactPhoto =
          'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fup.enterdesk.com%2Fedpic_source%2F53%2F0a%2Fda%2F530adad966630fce548cd408237ff200.jpg&refer=http%3A%2F%2Fup.enterdesk.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1641349181&t=4b9a02287d7062cde79ef52d05e3025c';
      if (contact.standbyState1 == 1) {
        return;
      }
      String pinyin = PinyinHelper.getFirstWordPinyin(contact.contactName ?? '').substring(0, 1);
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
    });

    map.keys.forEach((pinyin) {
      ContactListParent parent = ContactListParent();
      parent.title = pinyin;
      parent.child = map[pinyin];
      temp.add(parent);
    });
    _contactFilterData.value = temp;
  }

  _stickyChildList(List<ContactListItemEntity> data) => Container(
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return _contactItem(data[index]);
            }),
      );

  _newContact() => InkWell(
        onTap: () {
          NavigateUtil.push(context, ContactRouter.newContactPage);
        },
        child: Container(
          height: 64,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            //  搜索提示文字、图标
            ValueListenableBuilder<String>(
              valueListenable: _searchContent,
              builder: (context, value, child) {
                return Visibility(
                  visible: value.isEmpty,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                focusNode: _nodeSearch,
                controller: _searchController,
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  contentPadding: EdgeInsets.symmetric(horizontal: 6),
                  counterText: '',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  _searchContent.value = value;
                  //  数据筛选
                  List<ContactListItemEntity> temp = [];
                  if (value.isEmpty) {
                    temp = _contactSourceData;
                  } else {
                    _contactSourceData.forEach((element) {
                      if (element.contactName != null &&
                          value.isNotEmpty &&
                          element.contactName!.contains(value)) {
                        temp.add(element);
                        print(element);
                      }
                    });
                  }
                  _groupSourceData(temp);
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
        Padding(
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

  _contactItem(ContactListItemEntity data) => InkWell(
        onTap: () {
          NavigateUtil.push(
              context,
              '${ContactRouter.contactDetailPage}?isDevice=false'
              '&name=${Uri.encodeComponent(data.contactName ?? '')}'
              '&icon=${EncryptUtil.encodeBase64(data.contactPhoto ?? '')}'
              '&phone=${data.contactPhone}'
              '&group=${Uri.encodeComponent(data.type == 0 ? '其它' : '家人')}');
        },
        child: Container(
          height: 64,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gaps.hGap16,
              ClipOval(
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

  _devicePart() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
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
          _deviceList(),
        ],
      );

  _deviceList() => FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString('assets/data/ContactDeviceListData.json'),
      builder: (context, data) {
        //  json 解析为 List
        List result = json.decode(data.data.toString());
        //  List 元素转为具体对象
        _deviceData = result.map((element) => ContactHistoryDeviceBean.fromJson(element)).toList();
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _deviceData.length,
          itemBuilder: (context, index) => _deviceItem(_deviceData[index]),
        );
      });

  _deviceItem(ContactHistoryDeviceBean data) => InkWell(
        onTap: () {
          NavigateUtil.push(
              context,
              '${ContactRouter.contactDetailPage}?isDevice=true'
              '&name=${Uri.encodeComponent(data.name ?? '')}'
              '&icon=${EncryptUtil.encodeBase64('https://img1.baidu.com/it/u=2437536079,2390928705&fm=26&fmt=auto')}'
              '&phone=${data.simPhone}');
        },
        child: Container(
          height: 64,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gaps.hGap16,
              ClipOval(
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
}
