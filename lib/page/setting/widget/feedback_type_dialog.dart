import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/resources.dart';
import 'package:hello_flutter/widgets/NoScrollBehavior.dart';

typedef FeedbackSelect = Function(String);

YYDialog FeedbackTypeDialog(
  BuildContext context,
  FeedbackSelect feedbackSelect,
) {
  final List<String> _data = ['反馈类型', '硬件设备相关', 'App相关', '功能建议'];
  return YYDialog().build()
    ..gravity = Gravity.bottom
    ..gravityAnimationEnable = true
    ..backgroundColor = Colors.transparent
    ..widget(
      ScrollConfiguration(
        behavior: NoScrollBehavior(),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: _data.length,
          itemBuilder: (BuildContext context, int index) {
            //  圆角
            BorderRadiusGeometry radiu;
            if (index == 0) {
              radiu = BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              );
            } else if (index == _data.length - 1) {
              radiu = BorderRadius.only(
                bottomLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
              );
            } else {
              radiu = BorderRadius.all(Radius.circular(0));
            }

            return GestureDetector(
              onTap: () {
                if (index != 0) {
                  Navigator.of(context, rootNavigator: true).pop();
                }
                switch (index) {
                  case 1:
                  case 2:
                  case 3:
                    feedbackSelect(_data[index]);
                    break;
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: radiu,
                ),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Center(
                  child: Text(
                    _data[index],
                    style: TextStyle(
                      color: ColorConst.text,
                      fontSize: index == 0 ? 14 : 16,
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Divider(
              height: 0.5,
              color: ColorConst.bg_color,
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
          margin: EdgeInsets.only(bottom: 16, left: 12, right: 12, top: 8),
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
