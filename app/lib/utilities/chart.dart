import 'package:fl_chart/fl_chart.dart';

extension AxisTitlesUtil on AxisTitles {
  static AxisTitles hidden() =>
      AxisTitles(sideTitles: SideTitles(showTitles: false));
}
