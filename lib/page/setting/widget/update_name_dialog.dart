import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/util/toast_util.dart';

typedef UpdateName = Function(String);

void showUpdateNameDialog(
    BuildContext context, TextEditingController controller, UpdateName update) {
  SmartDialog.show(
    alignment: Alignment.center,
    builder: (context) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: TextField(
                  controller: controller,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    fillColor: ColorConst.bg_color,
                    filled: true,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Gaps.vGap24,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Gaps.hGap16,
                Expanded(
                  child: MaterialButton(
                    color: ColorConst.bg_color,
                    height: 44,
                    elevation: 0,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                    onPressed: () => SmartDialog.dismiss(),
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
                      SmartDialog.dismiss();
                      update(controller.text);
                    },
                    child: const Text(
                      "确定",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Gaps.hGap16,
              ],
            ),
            Gaps.vGap24,
          ],
        ),
      );
    },
  );
}
