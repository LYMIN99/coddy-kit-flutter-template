import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/integrations/utils/colors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';

class TransactionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TransactionScreenState();
}

class TransactionScreenState extends State<TransactionScreen> {
  final Color leftBarColor = TransactionLeft;
  final Color rightBarColor = TransactionRight;
  late final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    super.initState();
    final barGroup1 = makeGroupData(0, 5, 12);
    final barGroup2 = makeGroupData(1, 16, 12);
    final barGroup3 = makeGroupData(2, 18, 5);
    final barGroup4 = makeGroupData(3, 20, 16);
    final barGroup5 = makeGroupData(4, 17, 6);
    final barGroup6 = makeGroupData(5, 19, 1.5);
    final barGroup7 = makeGroupData(6, 10, 1.5);

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardColor,
      appBar: appBar(context, 'Transaction Chart'),
      body: Container(
        height: 300,
        child: BarChart(
          BarChartData(
            maxY: 20,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (BarChartGroupData group) => grey,
              ),
              touchCallback: (flTouchEvent, response) {
                // if (response.spot == null) {
                //   setState(() {
                //     touchedGroupIndex = -1;
                //     showingBarGroups = List.of(rawBarGroups);
                //   });
                //   return;
                // }
                //
                // touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                //
                // setState(() {
                //   if (response.touchInput is PointerExitEvent || response.touchInput is PointerUpEvent) {
                //     touchedGroupIndex = -1;
                //     showingBarGroups = List.of(rawBarGroups);
                //   } else {
                //     showingBarGroups = List.of(rawBarGroups);
                //     if (touchedGroupIndex != -1) {
                //       double sum = 0.0;
                //       for (var rod in showingBarGroups[touchedGroupIndex].barRods) {
                //         sum += rod.y;
                //       }
                //       final avg = sum / showingBarGroups[touchedGroupIndex].barRods.length;
                //
                //       showingBarGroups[touchedGroupIndex] = showingBarGroups[touchedGroupIndex].copyWith(
                //         barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                //           return rod.copyWith(y: avg);
                //         }).toList(),
                //       );
                //     }
                //   }
                // });
              },
            ),
            titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 20,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 0:
                          return Text('Mn', style: boldTextStyle(color: borderText));
                        case 1:
                          return Text('Te', style: boldTextStyle(color: borderText));

                        case 2:
                          return Text('Wd', style: boldTextStyle(color: borderText));

                        case 3:
                          return Text('Tu', style: boldTextStyle(color: borderText));

                        case 4:
                          return Text('Fr', style: boldTextStyle(color: borderText));

                        case 5:
                          return Text('St', style: boldTextStyle(color: borderText));

                        case 6:
                          return Text('Sn', style: boldTextStyle(color: borderText));

                        default:
                          return Text('', style: boldTextStyle(color: borderText));
                      }
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 32,
                    reservedSize: 14,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) {
                        return Text('1K', style: boldTextStyle(color: borderText));
                      } else if (value == 10) {
                        return Text('5K', style: boldTextStyle(color: borderText));
                      } else if (value == 19) {
                        return Text('10K', style: boldTextStyle(color: borderText));
                      } else {
                        return Text('1K', style: boldTextStyle(color: borderText));
                      }
                    },
                  ),
                )),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: showingBarGroups,
          ),
        ).center(),
      ).paddingAll(16).center(),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        toY: y1,
        color: leftBarColor,
        width: width,
      ),
      BarChartRodData(
        toY: y2,
        color: rightBarColor,
        width: width,
      ),
    ]);
  }
}
