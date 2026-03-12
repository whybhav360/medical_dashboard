import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import '../secrets.dart';

class CustomLineChart extends StatefulWidget {
  const CustomLineChart({super.key});

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  /// Fetches user data from Firestore using the `docId` defined in `secrets.dart`.
  /// Returns a map of the document data if successful, otherwise null.
  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(docId.trim())
          .get();
      return doc.data();
    } catch (e) {
      return null;
    }
  }

  /// Converts raw Firestore data for today's movement into `FlSpot` objects.
  ///
  /// Expects a list of maps with 'time' and 'value' keys.
  List<FlSpot> convertToday(List<dynamic>? raw) {
    if (raw == null) return [];
    return raw.map((e) {
      return FlSpot(
          (e['time'] as num).toDouble(), (e['value'] as num).toDouble());
    }).toList();
  }

  /// Converts raw Firestore history data into `FlSpot` objects.
  ///
  /// Uses the list index as the X-axis and 'rom' as the Y-axis.
  List<FlSpot> convertHistory(List<dynamic>? raw) {
    if (raw == null) return [];
    return raw.asMap().entries.map((entry) {
      return FlSpot(
          entry.key.toDouble(), (entry.value['rom'] as num).toDouble());
    }).toList();
  }

  /// Helper method to build a styled container for the charts.
  Widget buildChartCard(
      {required String title,
      required Widget chart,
      required String yAxisLabel,
      required String xAxisLabel}) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 12)),
          const SizedBox(height: 15),
          SizedBox(height: 180, child: chart),
          const SizedBox(height: 10),
          Center(
              child: Text(xAxisLabel,
                  style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data;
        if (data == null) return const Center(child: Text("Data not found"));

        final todaySpots = convertToday(data['movement_today']);
        final historyRaw = data['movement_history'] as List<dynamic>? ?? [];
        final historySpots = convertHistory(historyRaw);

        double maxTodayX = 1400;
        if (todaySpots.isNotEmpty) {
          maxTodayX =
              todaySpots.map((s) => s.x).reduce((a, b) => a > b ? a : b);
        }

        return Column(
          children: [
            buildChartCard(
              title: "MOVEMENT DATA",
              xAxisLabel: "TIME (S)",
              yAxisLabel: "Angle (°)",
              chart: LineChart(
                LineChartData(
                  minY: -20,
                  maxY: 50,
                  minX: 0,
                  maxX: maxTodayX,
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) =>
                          FlLine(color: Colors.grey.shade100, strokeWidth: 1)),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          interval: 20,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) => Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 10))),
                      axisNameWidget: const Text("Angle (°)",
                          style: TextStyle(fontSize: 10, color: Colors.grey)),
                      axisNameSize: 20,
                    ),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            interval: 200,
                            getTitlesWidget: (value, meta) => Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 10)))),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: todaySpots,
                      isCurved: true,
                      color: Colors.purple,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            buildChartCard(
              title: "HISTORY",
              xAxisLabel: "",
              yAxisLabel: "ROM (°)",
              chart: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 50,
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) =>
                          FlLine(color: Colors.grey.shade100, strokeWidth: 1)),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          interval: 10,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) => Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 10))),
                      axisNameWidget: const Text("ROM (°)",
                          style: TextStyle(fontSize: 10, color: Colors.grey)),
                      axisNameSize: 20,
                    ),
                    bottomTitles: AxisTitles(
                      axisNameSize: 30,
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < historyRaw.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(historyRaw[index]['date'] ?? '',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 10)),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: historySpots,
                      isCurved: true,
                      color: Colors.purple,
                      barWidth: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
