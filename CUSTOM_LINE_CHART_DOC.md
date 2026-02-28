# CustomLineChart Detailed Documentation

This document provides a line-by-line explanation of the `CustomLineChart` widget located in `lib/Widgets/custom_line_chart.dart`.

## Overview
The `CustomLineChart` is a `StatefulWidget` designed to fetch patient movement data from Firebase Firestore and visualize it using two distinct line charts: "Movement Data (Today)" and "History".

---

## 1. Imports and Setup
```dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import '../secrets.dart';
```
*   **`material.dart`**: Provides core Flutter UI components.
*   **`cloud_firestore.dart`**: Used to interact with the Firebase Firestore database.
*   **`fl_chart.dart`**: The charting library used for rendering the line graphs.
*   **`../secrets.dart`**: Contains the `docId` (the unique ID of the user document being tracked).

---

## 2. Data Fetching (`fetchUserData`)
```dart
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
```
*   **`FirebaseFirestore.instance.collection('users')`**: Targets the 'users' collection.
*   **`.doc(docId.trim())`**: Selects the specific document based on the `docId`.
*   **`.get()`**: An asynchronous call that retrieves the document snapshot.
*   **`.data()`**: Extracts the fields from the document as a `Map`.

---

## 3. Data Transformation

### `convertToday`
```dart
List<FlSpot> convertToday(List<dynamic>? raw) {
  if (raw == null) return [];
  return raw.map((e) {
    return FlSpot((e['time'] as num).toDouble(), (e['value'] as num).toDouble());
  }).toList();
}
```
*   Takes a raw list of maps from Firestore (e.g., `[{'time': 10, 'value': 20}, ...]`).
*   Maps each item to an **`FlSpot(x, y)`**, where `x` is time and `y` is the angle value.

### `convertHistory`
```dart
List<FlSpot> convertHistory(List<dynamic>? raw) {
  if (raw == null) return [];
  return raw.asMap().entries.map((entry) {
    return FlSpot(entry.key.toDouble(), (entry.value['rom'] as num).toDouble());
  }).toList();
}
```
*   Uses the **list index** (`entry.key`) as the X-axis coordinate.
*   Uses the **'rom'** (Range of Motion) field as the Y-axis coordinate.

---

## 4. UI Rendering (`build` method)

### `FutureBuilder`
```dart
return FutureBuilder<Map<String, dynamic>?>(
  future: fetchUserData(),
  builder: (context, snapshot) { ... }
)
```
*   Triggers `fetchUserData()` when the widget is built.
*   **`snapshot.connectionState == ConnectionState.waiting`**: Shows a loading spinner while data is being fetched.
*   **`final data = snapshot.data`**: Accesses the retrieved Firestore map.

### Dynamic X-Axis Scaling
```dart
double maxTodayX = 1400;
if (todaySpots.isNotEmpty) {
  maxTodayX = todaySpots.map((s) => s.x).reduce((a, b) => a > b ? a : b);
}
```
*   Finds the largest `x` value (time) in the dataset to ensure the chart's horizontal scale matches the data range.

---

## 5. Chart Configurations

### Movement Data (Today)
```dart
LineChartData(
  minY: -20, maxY: 50,
  minX: 0, maxX: maxTodayX,
  gridData: FlGridData(...),
  titlesData: FlTitlesData(
    leftTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: true, interval: 20, ...),
      axisNameWidget: Text("Angle (°)"),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: true, interval: 200, ...),
    ),
  ),
  lineBarsData: [
    LineChartBarData(
      spots: todaySpots,
      isCurved: true,
      color: primaryPurple,
      dotData: FlDotData(show: false),
    ),
  ],
)
```
*   **`minY/maxY`**: Fixed at -20 to 50 degrees to provide a consistent frame of reference for movement.
*   **`interval`**: Sets how frequently labels appear (every 20 units on Y, every 200 units on X).
*   **`isCurved: true`**: Smoothens the line between data points.
*   **`dotData: show: false`**: Hides individual points for a cleaner "continuous" look.

### History Chart
```dart
LineChartBarData(
  spots: historySpots,
  belowBarData: BarAreaData(show: true, color: primaryPurple.withOpacity(0.1)),
  dotData: FlDotData(show: true, getDotPainter: ...),
)
```
*   **`belowBarData`**: Adds a light purple fill under the line to emphasize the area/progress.
*   **`dotData: show: true`**: Shows circles at each data point, making individual session entries distinct.
*   **`bottomTitles`**: Uses the `date` string from the Firestore data as labels for the X-axis indices.

---

## 6. Helper Widget: `buildChartCard`
```dart
Widget buildChartCard({required String title, required Widget chart, ...}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.grey.shade100),
    ),
    child: Column(
      children: [
        Text(title, ...),
        SizedBox(height: 180, child: chart),
        Text(xAxisLabel, ...),
      ],
    ),
  );
}
```
*   Wraps the `fl_chart` in a stylized white card with rounded corners.
*   Ensures a consistent height of **180 pixels** for all graphs.
