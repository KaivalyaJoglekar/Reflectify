import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ActivityChart extends StatelessWidget {
  const ActivityChart({super.key});

  @override
  Widget build(BuildContext context) {
    // These values are for demonstration purposes
    final List<double> values = [0.8, 0.65, 0.4];
    final List<Color> colors = [Colors.green, Colors.yellow, Colors.red];
    const double radius = 40;
    const double thickness = 8;

    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(values.length, (index) {
          return SizedBox(
            width: (radius + index * (thickness + 4)) * 2,
            height: (radius + index * (thickness + 4)) * 2,
            child: PieChart(
              PieChartData(
                startDegreeOffset: -90,
                sectionsSpace: 0,
                centerSpaceRadius: radius + (index * (thickness + 4)),
                sections: [
                  PieChartSectionData(
                    value: values[index] * 100,
                    color: colors[index],
                    radius: thickness,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: (1 - values[index]) * 100,
                    color: Colors.white.withOpacity(0.1),
                    radius: thickness,
                    showTitle: false,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
