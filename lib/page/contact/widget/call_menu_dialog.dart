import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/resources.dart';
import 'package:hello_flutter/widgets/no_scroll_behavior.dart';

typedef CallClick = Function(int);

void showCallMenuDialog(
  BuildContext context,
  CallClick click,
) {
  final List<String> _data = ['通话', '视频电话', '语音电话', '普通电话'];
  SmartDialog.show(
    alignment: Alignment.bottomCenter,
    builder: (context) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16, left: 12, right: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              child: Card(
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: ScrollConfiguration(
                  behavior: NoScrollBehavior(),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          splashColor: index == 0 ? Colors.transparent : Theme.of(context).splashColor,
                          focusColor: index == 0 ? Colors.transparent : Theme.of(context).focusColor,
                          highlightColor: index == 0 ? Colors.transparent : Theme.of(context).highlightColor,
                          onTap: () {
                            if (index != 0) {
                              SmartDialog.dismiss();
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
                      separatorBuilder: (BuildContext context, int index) => const Divider(
                        height: 0.5,
                        color: ColorConst.dark_text,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => SmartDialog.dismiss(),
              child: Container(
                width: double.infinity,
                height: 50,
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
          ],
        ),
      );
    },
  );
}
