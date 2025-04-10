import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intelligent_mailbox_app/utils/date_time_utils.dart';

class NotificationsChart extends StatelessWidget {
  final List<int> counts; 

  const NotificationsChart({super.key, required this.counts});

  @override
  Widget build(BuildContext context) {
    final weekDays = DateTimeUtils.getWeekDays(context);

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < weekDays.length) {
                    return Text(
                      weekDays[index],
                      style: Theme.of(context).textTheme.bodyMedium,
                    );
                  }
                  return const Text('');
                },
                interval: 1,
                reservedSize: 45,
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          barGroups: List.generate(
            counts.length,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: counts[index].toDouble(),
                  color: Colors.blue,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
          alignment: BarChartAlignment.center,
        ),
        
      ),
    );
  }
}
