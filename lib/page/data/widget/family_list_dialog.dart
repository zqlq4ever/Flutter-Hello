import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hello_flutter/models/contact_list/family_list_entity.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/resources.dart';
import 'package:hello_flutter/widgets/no_scroll_behavior.dart';

typedef ContactCallback = Function(FamilyListEntity);

void showFamilyListDialog(
  BuildContext context,
  List<FamilyListEntity> data,
  ContactCallback callback,
) {
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
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
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
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) => InkWell(
                        onTap: () {
                          SmartDialog.dismiss();
                          callback(data[index]);
                        },
                        child: SizedBox(
                          height: 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: index != 0,
                                child: Container(
                                  height: 0.5,
                                  color: ColorConst.bg_color,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 39,
                                child: Text(
                                  data[index].contactName ?? "",
                                  style: const TextStyle(color: ColorConst.text),
                                ),
                              ),
                            ],
                          ),
                        ),
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
