import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/page/data/controller/data_chart_controller.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/util/log_util.dart';

/// 数据图表
class DataChartPage extends GetView<DataChartController> {
  const DataChartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DataChartController());
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Gaps.vGap24,
          _labels(),
          Gaps.vGap24,
          _chart(),
        ],
      ),
    );
  }

  AspectRatio _chart() {
    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          maxY: 100,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: ColorConst.text_gray,
              getTooltipItem: (_a, _b, _c, _d) => null,
            ),
            touchCallback: (FlTouchEvent event, response) {
              //
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: SideTitles(showTitles: false),
            topTitles: SideTitles(showTitles: false),
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(
                color: ColorConst.text_gray,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              margin: 8,
              getTitles: (double value) {
                Logger.d(value.toString());
                return controller.xData[value.toInt()];
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(
                color: ColorConst.text_gray,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              margin: 0,
              reservedSize: 28,
              interval: 1,
              getTitles: (value) {
                if (value == 0) {
                  return '0';
                } else if (value == 50) {
                  return '50';
                } else if (value == 100) {
                  return '100';
                } else {
                  return '';
                }
              },
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: controller.showingBarGroups,
          gridData: FlGridData(show: false),
        ),
      ),
    );
  }

  Row _labels() {
    return Row(
      children: [
        _label('高压', controller.leftBarColor),
        Gaps.hGap8,
        _label('低压', controller.middleBarColor),
        Gaps.hGap8,
        _label('心率', controller.rightBarColor),
      ],
    );
  }

  Row _label(String labelName, Color labeColor) {
    return Row(
      children: [
        Container(
          height: 10,
          width: 10,
          color: labeColor,
        ),
        Gaps.hGap4,
        Text(
          labelName,
          style: const TextStyle(
            fontSize: 12,
            color: ColorConst.text_gray,
          ),
        ),
      ],
    );
  }
}
