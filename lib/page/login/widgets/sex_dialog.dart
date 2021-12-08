import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/resources.dart';
import 'package:hello_flutter/widgets/no_scroll_behavior.dart';

typedef SexCallBack = Function(String);

YYDialog showSexSelectDialog(BuildContext context, SexCallBack callBack) {
  final List<String> _data = ['性别', '男', '女'];
  return YYDialog().build()
    ..gravity = Gravity.bottom
    ..gravityAnimationEnable = true
    ..backgroundColor = Colors.transparent
    ..widget(
      MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: ScrollConfiguration(
            behavior: NoScrollBehavior(),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _data.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    switch (index) {
                      case 1:
                      case 2:
                        Navigator.of(context, rootNavigator: true).pop();
                        callBack(_data[index]);
                        break;
                    }
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Center(
                      child: Text(
                        _data[index],
                        style: TextStyle(
                          color: index == 0 ? ColorConst.text_gray : ColorConst.text,
                          fontSize: index == 0 ? 14 : 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(
                height: 0.5,
                color: ColorConst.line,
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
          margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: const Center(
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
