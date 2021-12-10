import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DataChartController extends GetxController {
  final Color leftBarColor = const Color(0xff5B8FF9);
  final Color middleBarColor = const Color(0xff5AD8A6);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 6;
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  List<String> xData = [
    '06-08',
    '06-09',
    '06-10',
    '06-11',
    '06-12',
    '06-13',
    '06-13',
  ];

  @override
  void onInit() {
    super.onInit();

    final barGroup1 = makeGroupData(0, 5, 12, 66);
    final barGroup2 = makeGroupData(1, 60, 80, 88);
    final barGroup3 = makeGroupData(2, 68, 73, 95);
    final barGroup4 = makeGroupData(3, 50, 85, 100);
    final barGroup5 = makeGroupData(4, 88, 66, 44);
    final barGroup6 = makeGroupData(5, 30, 40, 33);
    final barGroup7 = makeGroupData(6, 10, 100, 66);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;
    showingBarGroups = rawBarGroups;
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2, double y3) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [leftBarColor],
        width: width,
      ),
      BarChartRodData(
        y: y2,
        colors: [middleBarColor],
        width: width,
      ),
      BarChartRodData(
        y: y3,
        colors: [rightBarColor],
        width: width,
      ),
    ]);
  }
}
