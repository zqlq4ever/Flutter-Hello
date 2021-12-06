import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/models/contact_list/family_list_entity.dart';
import 'package:hello_flutter/page/dataitem/data_router.dart';
import 'package:hello_flutter/page/dataitem/widget/family_list_dialog.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/router/fluro_navigate_util.dart';
import 'package:hello_flutter/util/toast_util.dart';
import 'package:hello_flutter/widgets/NoScrollBehavior.dart';
import 'package:hello_flutter/widgets/load_image.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';

/// 首页 - 数据
class DataItemPage extends StatefulWidget {
  const DataItemPage({Key? key}) : super(key: key);

  @override
  _DataItemPageState createState() => _DataItemPageState();
}

class _DataItemPageState extends State<DataItemPage> {
  ValueNotifier<String> _selectName = ValueNotifier<String>('选择家庭成员');

  List<Container>? data;
  int id = 0;

  List<Container> _buildItems() {
    if (data == null) {
      const _itemBg = [
        'bg_heart_rate',
        'bg_temp',
        'bg_blood_oxygen',
      ];
      data = List.generate(
        _itemBg.length,
        (index) => Container(
          decoration: BoxDecoration(
            //  设置四周圆角角度
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: GestureDetector(
            onTap: () {
              if (id == 0) {
                ToastUtil.show('请先选择家庭成员');
                return;
              }
              switch (index) {
                case 0:
                  NavigateUtil.push(
                      context,
                      '${DataRouter.dataDetailPage}?'
                      'title=${Uri.encodeComponent('血压/心率')}'
                      '&name=${Uri.encodeComponent(_selectName.value)}'
                      '&id=&$id');
                  break;
                case 1:
                  NavigateUtil.push(
                      context,
                      '${DataRouter.dataDetailPage}?'
                      'title=${Uri.encodeComponent('体温')}'
                      '&name=${Uri.encodeComponent(_selectName.value)}'
                      '&id=&$id');
                  break;
                case 2:
                  NavigateUtil.push(
                      context,
                      '${DataRouter.dataDetailPage}?'
                      'title=${Uri.encodeComponent('血氧饱和度')}'
                      '&name=${Uri.encodeComponent(_selectName.value)}'
                      '&id=&$id');
                  break;
              }
            },
            child: LoadAssetImage(_itemBg[index]),
          ),
        ),
      );
    }
    return data!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.bg_color,
      appBar: MyAppBar(
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
          DefaultAssetBundle.of(context)
              .loadString('assets/data/FamilyContactData.json')
              .then((value) {
            //  json 解析为 List
            List result = json.decode(value);
            //  List 元素转为具体对象
            List<FamilyListEntity> temp =
                result.map((element) => FamilyListEntity.fromJson(element)).toList();
            FamilyListDialog(context, temp, (contact) {
              id = contact.id ?? 0;
              _selectName.value = contact.contactName ?? '';
            });
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ValueListenableBuilder<String>(
                valueListenable: _selectName,
                builder: (context, value, child) {
                  return Text(
                    value,
                    style: TextStyle(
                      color: ColorConst.text,
                      fontSize: 14,
                    ),
                  );
                }),
            Icon(
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
        padding: EdgeInsets.symmetric(horizontal: 16.0),
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
}
