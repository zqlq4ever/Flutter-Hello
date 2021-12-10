import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/page/login/page/default_header_page.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/resources.dart';
import 'package:hello_flutter/widgets/no_scroll_behavior.dart';

typedef DefaultHeader = Function(String);
typedef ImageClick = Function(bool);

/// 选择头像菜单
YYDialog showHeaderMenuDialog(
  BuildContext context,
  ImageClick imagePicker,
  DefaultHeader header,
) {
  YYDialog.init(context);
  final List<String> _data = ['更改头像', '默认头像', '相册', '拍照'];
  return YYDialog().build()
    ..gravity = Gravity.bottom
    ..gravityAnimationEnable = true
    ..backgroundColor = Colors.transparent
    ..widget(
      ScrollConfiguration(
        behavior: NoScrollBehavior(),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: Card(
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            child: SingleChildScrollView(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: _menuList(_data, imagePicker, header),
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
          margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
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

_menuList(
  List<String> _data,
  ImageClick imagePicker,
  DefaultHeader header,
) =>
    ListView.separated(
      shrinkWrap: true,
      itemCount: _data.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          splashColor: index == 0 ? Colors.transparent : Theme.of(context).splashColor,
          focusColor: index == 0 ? Colors.transparent : Theme.of(context).focusColor,
          highlightColor: index == 0 ? Colors.transparent : Theme.of(context).highlightColor,
          onTap: () async {
            if (index != 0) {
              Navigator.of(context, rootNavigator: true).pop();
            }
            switch (index) {
              //  默认头像
              case 1:
                var headerName = await Get.to(() => const DefautHeaderPage());
                header(headerName ?? "return");
                break;
              //  相册
              case 2:
                imagePicker(false);
                break;
              //  拍照
              case 3:
                imagePicker(true);
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
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 0.5,
        color: ColorConst.dark_text,
      ),
    );
