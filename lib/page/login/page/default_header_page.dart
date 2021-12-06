import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/router/fluro_navigate_util.dart';
import 'package:hello_flutter/widgets/load_image.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';
import 'package:hello_flutter/widgets/my_button.dart';

/// 登录 - 注册 - 完善个人信息 - 默认头像
class DefautHeaderPage extends StatefulWidget {
  const DefautHeaderPage({Key? key}) : super(key: key);

  @override
  _DefautHeaderPageState createState() => _DefautHeaderPageState();
}

class _DefautHeaderPageState extends State<DefautHeaderPage> {
  final List<String> data = [
    'ic_header_boy',
    'ic_header_dad',
    'ic_header_girl',
    'ic_header_mom',
    'ic_header_grandma',
    'ic_header_grandpa',
  ];
  int selectedIndex = 0;
  double screenWidth = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
      );
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: MyAppBar(
        isBack: true,
        centerTitle: '选择头像',
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: ColorConst.bg_color,
        width: screenWidth,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Gaps.vGap24,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: _buildBody,
            ),
            Gaps.vGap50,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: MyButton(
                onPressed: () {
                  // Toast.show(selectedIndex.toString());
                  NavigateUtil.goBackWithParams(context, data[selectedIndex]);
                },
                text: '确定',
                radius: 24,
              ),
            )
          ],
        ),
      ),
    );
  }

  get _buildBody => GridView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      // SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量 Widget
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //  横轴元素个数
          crossAxisCount: 3,
          //  纵轴间距
          mainAxisSpacing: 25.0,
          //  横轴间距
          crossAxisSpacing: 32.0,
          //  子组件宽高长度比例
          childAspectRatio: 1.0),
      itemBuilder: (BuildContext context, int index) {
        double width = 0;
        if (selectedIndex == index) {
          width = 3;
        } else {
          width = 0;
        }
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: new Border.all(
                  color: ColorConst.app_main,
                  width: width,
                ),
                borderRadius: BorderRadius.circular(200),
              ),
              child: GestureDetector(
                onTap: () {
                  selectedIndex = index;
                  setState(() {});
                },
                child: LoadAssetImage(data[index]),
              ),
            ),
            Visibility(
              visible: selectedIndex == index,
              child: Positioned(
                right: 10,
                child: LoadAssetImage(
                  'ic_selected',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ],
        );
      });
}
