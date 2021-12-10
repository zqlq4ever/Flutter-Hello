import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/page/data/controller/data_single_controller.dart';
import 'package:hello_flutter/res/colors.dart';

/// 单次测量数据
class DataSinglePage extends GetView<DataSingleController> {
  const DataSinglePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          '',
          style: TextStyle(
            fontSize: 16,
            color: ColorConst.text,
          ),
        )
      ],
    );
  }
}
