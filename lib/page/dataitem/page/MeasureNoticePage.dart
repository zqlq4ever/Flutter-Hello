import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/widgets/load_image.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';

/// 数据 - 数据图表
class MeasureNoticePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: MyAppBar(
          backgroundColor: Colors.white,
          centerTitle: '测量说明',
          onRightPressed: () {},
        ),
        body: LoadImage('measure_notice'),
      );
}
