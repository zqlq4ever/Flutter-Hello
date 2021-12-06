import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:hello_flutter/models/contact_list/family_list_entity.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/resources.dart';
import 'package:hello_flutter/widgets/NoScrollBehavior.dart';

typedef ContactCallback = Function(FamilyListEntity);

YYDialog FamilyListDialog(
  BuildContext context,
  List<FamilyListEntity> data,
  ContactCallback callback,
) {
  YYDialog.init(context);
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
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
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
                child: _contactList(data, callback),
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

_contactList(
  List<FamilyListEntity> data,
  ContactCallback callback,
) =>
    ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) => InkWell(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pop();
          callback(data[index]);
        },
        child: Container(
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
                  style: TextStyle(color: ColorConst.text),
                ),
              ),
            ],
          ),
        ),
      ),
    );
