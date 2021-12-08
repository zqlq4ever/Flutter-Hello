import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/util/toast_util.dart';

typedef UpdateName = Function(String);

YYDialog showUpdateNameDialog(BuildContext context, UpdateName update) {
  YYDialog.init(context);
  TextEditingController controller = TextEditingController();
  return YYDialog().build()
    ..gravity = Gravity.center
    ..gravityAnimationEnable = true
    ..backgroundColor = Colors.transparent
    ..duration = const Duration(milliseconds: 250)
    ..animatedFunc = (child, animation) {
      return ScaleTransition(
        child: child,
        scale: Tween(begin: 0.2, end: 1.0).animate(animation),
      );
    }
    ..widget(
      Card(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gaps.vGap16,
            const Text(
              '称呼',
              style: TextStyle(
                color: ColorConst.text,
                fontSize: 16,
              ),
            ),
            Gaps.vGap16,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    //  背景颜色，必须结合 filled: true,才有效
                    fillColor: ColorConst.bg_color,
                    //  重点，必须设置为 true，fillColor才有效
                    filled: true,
                    //  重点，相当于高度包裹的意思，必须设置为true，不然有默认奇妙的最小高度
                    isCollapsed: true,
                    //  内容内边距，影响高度
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    //边框
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Gaps.vGap24,
            _button(context, update, controller),
            Gaps.vGap24,
          ],
        ),
      ),
    )
    ..show();
}

Row _button(BuildContext context, UpdateName callBack, TextEditingController controller) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Gaps.hGap16,
      Expanded(
        child: MaterialButton(
          color: ColorConst.bg_color,
          height: 44,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text("取消"),
        ),
      ),
      Gaps.hGap16,
      Expanded(
        child: MaterialButton(
          height: 44,
          color: ColorConst.app_main,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          onPressed: () {
            if (controller.text.isEmpty) {
              ToastUtil.show('名字不能为空');
              return;
            }
            Navigator.of(context, rootNavigator: true).pop();
            callBack(controller.text);
          },
          child: const Text(
            "确定",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      Gaps.hGap16,
    ],
  );
}
