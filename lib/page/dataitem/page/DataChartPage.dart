import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';

/// 数据图表
class DataChartPage extends StatefulWidget {
  const DataChartPage({
    Key? key,
    this.title = '',
    this.name = '',
    this.id = '',
  }) : super(key: key);

  final String title;
  final String name;
  final String id;

  @override
  _DataChartPageState createState() => _DataChartPageState();
}

class _DataChartPageState extends State<DataChartPage> {
  final Color leftBarColor = const Color(0xff5B8FF9);
  final Color middleBarColor = const Color(0xff5AD8A6);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 6;
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  List<String> x_data = [
    '06-08',
    '06-09',
    '06-10',
    '06-11',
    '06-12',
    '06-13',
    '06-13',
  ];

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

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Gaps.vGap24,
            _labels(),
            Gaps.vGap24,
            _chart(),
          ],
        ),
      );

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
                print(value);
                return x_data[value.toInt()];
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
          barGroups: showingBarGroups,
          gridData: FlGridData(show: false),
        ),
      ),
    );
  }

  Row _labels() {
    return Row(
      children: [
        _label('高压', leftBarColor),
        Gaps.hGap8,
        _label('低压', middleBarColor),
        Gaps.hGap8,
        _label('心率', rightBarColor),
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
          style: TextStyle(
            fontSize: 12,
            color: ColorConst.text_gray,
          ),
        ),
      ],
    );
  }
}
