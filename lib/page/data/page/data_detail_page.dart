import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/models/contact_list/family_list_entity.dart';
import 'package:hello_flutter/page/data/data_router.dart';
import 'package:hello_flutter/page/data/page/data_chart_page.dart';
import 'package:hello_flutter/page/data/page/data_single_page.dart';
import 'package:hello_flutter/page/data/widget/family_list_dialog.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/router/fluro_navigate_util.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';

/// 数据 - 数据图表
class DataDetailPage extends StatefulWidget {
  const DataDetailPage({
    Key? key,
    this.title = '',
    this.name = '',
    this.id = '',
  }) : super(key: key);

  final String title;
  final String name;
  final String id;

  @override
  _DataDetailPageState createState() => _DataDetailPageState();
}

class _DataDetailPageState extends State<DataDetailPage> with TickerProviderStateMixin {
  TabController? tabController;
  final PageController _pageController = PageController();
  final ValueNotifier<String> _selectTitle = ValueNotifier<String>('选择家庭成员');

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    _selectTitle.value = widget.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: ColorConst.bg_color,
        appBar: MyAppBar(
          backgroundColor: Colors.white,
          centerTitle: widget.title,
          rightText: '说明',
          onRightPressed: () => NavigateUtil.push(context, DataRouter.noticePage),
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
                  DataSinglePage(),
                  DataChartPage(),
                ],
                onPageChanged: (index) => tabController?.animateTo(index),
                controller: _pageController,
              ),
            ),
          ],
        ),
      );

  Container _selectContact(BuildContext context) => Container(
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
              showFamilyListDialog(context, temp, (contact) {
                _selectTitle.value = contact.contactName ?? '';
              });
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ValueListenableBuilder<String>(
                  valueListenable: _selectTitle,
                  builder: (context, value, child) {
                    return Text(
                      value,
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
              _pageController.jumpToPage(index);
            },
            labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 16),
            isScrollable: true,
            controller: tabController,
            labelColor: ColorConst.app_main,
            indicatorWeight: 3,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
            unselectedLabelColor: ColorConst.text_gray,
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
