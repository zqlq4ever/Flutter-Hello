import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/resources.dart';
import 'package:hello_flutter/widgets/no_scroll_behavior.dart';

typedef SexCallBack = Function(String);

void showSexSelectDialog(BuildContext context, SexCallBack callBack) {
  final List<String> _data = ['性别', '男', '女'];
  SmartDialog.show(
    alignment: Alignment.bottomCenter,
    builder: (context) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
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
                            SmartDialog.dismiss();
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
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => SmartDialog.dismiss(),
              child: Container(
                width: double.infinity,
                height: 50,
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
          ],
        ),
      );
    },
  );
}
