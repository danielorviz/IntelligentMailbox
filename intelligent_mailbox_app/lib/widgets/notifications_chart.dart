import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class NotificationsChart extends StatelessWidget {
  final List<DateTime> dates;
  final List<int> counts;

  const NotificationsChart({super.key, required this.dates, required this.counts});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < dates.length) {
                    return Text(dates[index].toString().split(' ')[0]);
                  }
                  return Text('');
                },
                interval: 1,
                reservedSize: 45,
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                counts.length,
                (index) => FlSpot(index.toDouble(), counts[index].toDouble()),
              ),
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
