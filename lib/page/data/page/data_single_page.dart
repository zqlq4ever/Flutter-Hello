import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/res/colors.dart';

/// 单次测量数据
class DataSinglePage extends StatefulWidget {
  const DataSinglePage({
    Key? key,
    this.title = '',
    this.name = '',
    this.id = '',
  }) : super(key: key);

  final String title;
  final String name;
  final String id;

  @override
  _DataSinglePageState createState() => _DataSinglePageState();
}

class _DataSinglePageState extends State<DataSinglePage> {
  @override
  Widget build(BuildContext context) => Column(
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
