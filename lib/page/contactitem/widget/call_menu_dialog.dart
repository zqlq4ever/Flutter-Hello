import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/resources.dart';
import 'package:hello_flutter/widgets/NoScrollBehavior.dart';

typedef CallClick = Function(int);

/// 选择头像菜单
YYDialog CallMenuDialog(
  BuildContext context,
  CallClick click,
) {
  YYDialog.init(context);
  final List<String> _data = ['通话', '视频电话', '语音电话', '普通电话'];
  return YYDialog().build()
    ..gravity = Gravity.bottom
    ..gravityAnimationEnable = true
    ..backgroundColor = Colors.transparent
    ..widget(
      ScrollConfiguration(
        behavior: NoScrollBehavior(),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 12),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            child: SingleChildScrollView(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: _menuList(_data, click),
              ),
            ),
          ),
        ),
      ),
    )
    ..widget(
      GestureDetector(
        onTap: () => Navigator.of(context, rootNavigator: true).pop(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              "取消",
              style: TextStyle(
                color: ColorConst.text,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    )
    ..show();
}

_menuList(
  List<String> _data,
  CallClick click,
) =>
    ListView.separated(
      shrinkWrap: true,
      itemCount: _data.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          splashColor: index == 0 ? Colors.transparent : Theme.of(context).splashColor,
          focusColor: index == 0 ? Colors.transparent : Theme.of(context).focusColor,
          highlightColor: index == 0 ? Colors.transparent : Theme.of(context).highlightColor,
          onTap: () {
            if (index != 0) {
              Navigator.of(context, rootNavigator: true).pop();
            }
            switch (index) {
              case 1:
              case 2:
              case 3:
                click(index);
                break;
            }
          },
          child: Container(
            alignment: Alignment.center,
            height: 50,
            child: Text(
              _data[index],
              style: TextStyle(
                color: index == 0 ? ColorConst.text_gray : ColorConst.text,
                fontSize: index == 0 ? 14 : 16,
              ),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 0.5,
        color: ColorConst.dark_text,
      ),
    );
