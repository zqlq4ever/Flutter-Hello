import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/resources.dart';
import 'package:hello_flutter/widgets/no_scroll_behavior.dart';

typedef FeedbackSelect = Function(String);

void showFeedbackTypeDialog(
  BuildContext context,
  FeedbackSelect feedbackSelect,
) {
  final List<String> _data = ['反馈类型', '硬件设备相关', 'App相关', '功能建议'];
  SmartDialog.show(
    alignment: Alignment.bottomCenter,
    builder: (context) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16, left: 12, right: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScrollConfiguration(
              behavior: NoScrollBehavior(),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _data.length,
                itemBuilder: (BuildContext context, int index) {
                  BorderRadiusGeometry radiu;
                  if (index == 0) {
                    radiu = const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    );
                  } else if (index == _data.length - 1) {
                    radiu = const BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    );
                  } else {
                    radiu = const BorderRadius.all(Radius.circular(0));
                  }

                  return GestureDetector(
                    onTap: () {
                      if (index != 0) {
                        SmartDialog.dismiss();
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
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
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
                separatorBuilder: (BuildContext context, int index) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Divider(
                    height: 0.5,
                    color: ColorConst.bg_color,
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
