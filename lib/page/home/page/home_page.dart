import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/page/contactitem/page/ContactItemPage.dart';
import 'package:hello_flutter/page/dataitem/page/DataItemPage.dart';
import 'package:hello_flutter/page/homeitem/page/HomeItemPage.dart';
import 'package:hello_flutter/res/resources.dart';
import 'package:hello_flutter/widgets/double_tap_back_exit_app.dart';
import 'package:hello_flutter/widgets/load_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  late List<Widget> _pageList;
  final List<String> _appBarTitles = ['我的家', '通讯', '数据'];
  List<BottomNavigationBarItem>? _list;
  var _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DoubleTapBackExitApp(
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pageList,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: _bottomNavigationBarItem(),
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          elevation: 5.0,
          iconSize: 21.0,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: ColorConst.unselected_item_color,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _bottomNavigationBarItem() {
    if (_list == null) {
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
      _list = List.generate(
        _tabImages.length,
        (index) => BottomNavigationBarItem(
          icon: _tabImages[index][0],
          activeIcon: _tabImages[index][1],
          label: _appBarTitles[index],
        ),
      );
    }
    return _list!;
  }

  void initData() {
    _pageList = [
      HomeItemPage(),
      ContactItemPage(),
      DataItemPage(),
    ];
  }
}
