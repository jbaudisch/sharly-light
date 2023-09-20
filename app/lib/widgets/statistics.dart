import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sharly_app_light/utilities/extensions.dart';
import 'package:sharly_app_light/utilities/math.dart';
import 'package:sharly_app_light/utilities/string_res.dart';

import '../utilities/chart.dart';

class Statistics extends StatelessWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const children = [DailyActivity(), WeeklyActivity()];
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.count(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        childAspectRatio: 16 / 10,
        crossAxisCount: min(
            (MediaQuery.of(context).size.width / 600).round(), children.length),
        children: children,
      ),
    );
  }
}

class DailyActivity extends StatelessWidget {
  const DailyActivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final time = DateTime.now();
    final random = Random(42);
    return Statistic(
      title: s(context).statisticDaily,
      xLabel: s(context).metricHours,
      yLabel: s(context).metricActivity,
      points: List.generate(
          time.hour,
          (index) => FlSpot(
              index.toDouble(), // + 1,
              (max(
                      normalDistribution(index.toDouble(), 12, 15) * 60 +
                          (random.nextDouble() - 0.5),
                      0.0))
                  .roundFixed(2))),
    );
  }
}

class WeeklyActivity extends StatelessWidget {
  const WeeklyActivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final time = DateTime.now();

    final random = Random(2);
    final format = DateFormat.E("de");

    // Random walk
    final walkData = [random.nextDouble()];
    for (int i = 0; i < 7; i++) {
      walkData.add(max(walkData.last + 2 * (random.nextDouble() - 0.5), 0.0)
          .roundFixed(2));
    }

    return Statistic(
      title: s(context).statisticWeekly,
      xLabel: s(context).metricDay,
      yLabel: s(context).metricActivity,
      points: walkData.mapWithIndex((i, e) => FlSpot(i.toDouble(), e)),
      titles: FlTitlesData(
          topTitles: AxisTitlesUtil.hidden(),
          rightTitles: AxisTitlesUtil.hidden(),
          leftTitles: AxisTitles(
              axisNameSize: 30,
              axisNameWidget: Text(s(context).metricActivity),
              sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
          bottomTitles: AxisTitles(
              axisNameWidget: Text(s(context).metricDay),
              axisNameSize: 30,
              sideTitles: SideTitles(
                  interval: 1,
                  reservedSize: 40,
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(format
                            .format(time.add(Duration(days: value.toInt())))));
                  }))),
    );
  }
}

class Statistic extends StatelessWidget {
  const Statistic(
      {Key? key,
      required this.title,
      required this.xLabel,
      required this.yLabel,
      required this.points,
      this.titles})
      : super(key: key);

  final String title;
  final String xLabel;
  final String yLabel;
  final List<FlSpot> points;
  final FlTitlesData? titles;

  @override
  Widget build(BuildContext context) {
    final color = HSLColor.fromColor(Theme.of(context).colorScheme.primary)
        .withSaturation(1)
        .toColor();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
            child: LineChart(LineChartData(
                lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor:
                            Theme.of(context).colorScheme.surfaceVariant,
                        getTooltipItems: (touchedBarSpots) => touchedBarSpots
                            .map((e) => LineTooltipItem(e.x.toString(),
                                Theme.of(context).textTheme.bodyMedium!))
                            .toList())),
                titlesData: titles ??
                    FlTitlesData(
                        rightTitles: AxisTitlesUtil.hidden(),
                        leftTitles: AxisTitles(
                            // axisNameSize: 20,
                            axisNameWidget: Text(yLabel),
                            sideTitles:
                                SideTitles(showTitles: true, reservedSize: 40)),
                        topTitles: AxisTitlesUtil.hidden(),
                        bottomTitles: AxisTitles(
                            sideTitles:
                                SideTitles(showTitles: true, reservedSize: 30),
                            axisNameSize: 30,
                            axisNameWidget: Text(xLabel))),
                lineBarsData: [
              LineChartBarData(
                isStrokeCapRound: true,
                barWidth: 5,
                color: color,
                spots: points,
                curveSmoothness: 0.02,
                isCurved: true,
                dotData: FlDotData(show: false),
                belowBarData:
                    BarAreaData(show: true, color: color.withAlpha(100)),
              )
            ])))
      ],
    );
  }
}
