import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/carbon_intensity_model.dart';
import 'home_screen_controller.dart';

class IntensityChart extends StatelessWidget {
  final List<Intensity> dataPoints;

  IntensityChart({super.key, required this.dataPoints});
  final HomeScreenController homeScreenCont = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    if (dataPoints.isEmpty) {
      return const Center(
        child: Text(
          "No data available",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          show: true,
          leftTitles: AxisTitles(
            axisNameWidget: const Text(
              "Carbon Intensity (gCO₂/kWh)",
              style: TextStyle(color: Colors.white),
            ),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              interval: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            axisNameWidget: const Text(
              "Time (HH:MM)",
              style: TextStyle(color: Colors.white),
            ),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: (dataPoints.length / 4).floorToDouble(),
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < dataPoints.length) {
                  DateTime startTime = DateTime(2024, 11, 2, 23, 30);
                  DateTime labelTime =
                      startTime.add(Duration(minutes: index * 30));
                  String formattedTime =
                      "${labelTime.hour.toString().padLeft(2, '0')}:${labelTime.minute.toString().padLeft(2, '0')}";
                  return Text(
                    formattedTime,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 4),
        ),
        lineBarsData: [
          _createLineChartBarData(dataPoints, true),
          _createLineChartBarData(dataPoints, false),
        ],
        minX: 0,
        maxX: (dataPoints.length - 1).toDouble(),
        minY: (homeScreenCont.minForecastValue.value - 50).toDouble(),
        maxY: (homeScreenCont.maxForecastValue.value + 50).toDouble(),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((touchedSpot) {
                final x = touchedSpot.x.toInt();
                final intensity = dataPoints[x];
                Color indexColor = getIndexColor(intensity.index);

                if (touchedSpot.barIndex == 0) {
                  return LineTooltipItem(
                    'Time: ${_formatTime(x)}\nForecast: ${intensity.forecast}\nActual: ${intensity.actual ?? "N/A"}\nIndex: ${intensity.index}',
                    TextStyle(
                      color: indexColor,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else if (touchedSpot.barIndex == 1 &&
                    intensity.actual != null) {
                  return null;
                }
                return null;
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  LineChartBarData _createLineChartBarData(
      List<Intensity> data, bool isForecast) {
    List<FlSpot> spots = [];
    for (int i = 0; i < data.length; i++) {
      var value = isForecast ? data[i].forecast : data[i].actual;
      if (value != null || isForecast) {
        spots.add(FlSpot(i.toDouble(), value?.toDouble() ?? 0.0));
      }
    }

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: isForecast ? Colors.blue : Colors.red,
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  String _formatTime(int index) {
    DateTime startTime = DateTime(2024, 11, 2, 23, 30);
    DateTime labelTime = startTime.add(Duration(minutes: index * 30));
    return "${labelTime.hour.toString().padLeft(2, '0')}:${labelTime.minute.toString().padLeft(2, '0')}";
  }

  Color getIndexColor(String index) {
    Color indexValueColor = Colors.white;

    switch (index) {
      case 'very low':
        indexValueColor = Colors.green;
        break;
      case 'low':
        indexValueColor = Colors.yellow;
        break;
      case 'moderate':
        indexValueColor = Colors.orangeAccent;
        break;
      case 'high':
        indexValueColor = const Color.fromARGB(255, 255, 123, 0);
        break;
      case 'very high':
        indexValueColor = Colors.red;
        break;
    }
    return indexValueColor;
  }
}
