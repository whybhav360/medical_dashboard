# Medical Dashboard

A Flutter-based medical dashboard application for tracking movement data and history.

## Custom Line Chart Documentation

The `CustomLineChart` widget (`lib/Widgets/custom_line_chart.dart`) is a core component of this dashboard, responsible for visualizing patient recovery data.

### Packages Used

*   **`fl_chart`**: A powerful Flutter chart library used to render the line graphs. It provides the `LineChart`, `LineChartData`, and `FlSpot` classes used to plot the data points.
*   **`cloud_firestore`**: The Firebase Cloud Firestore plugin used to fetch real-time (or static) data from the NoSQL database.
*   **`secrets.dart`**: A private file (excluded from VCS) containing the `docId` used to identify the specific user document in Firestore.

### Data Fetching Process

1.  **Firebase Connection**: The widget uses `FirebaseFirestore.instance` to access the database.
2.  **Document Retrieval**: The `fetchUserData()` method is an asynchronous function that fetches a document from the `users` collection using the `docId`.
3.  **FutureBuilder**: A `FutureBuilder` is used in the `build` method to manage the UI state based on the asynchronous fetch (loading, error, or data found).

### Data Representation

The widget displays two distinct charts:

#### 1. Movement Data (Today)
*   **Source**: The `movement_today` field in Firestore (a list of maps).
*   **Transformation**: `convertToday()` maps each entry's `time` (X-axis) and `value` (Y-axis) to an `FlSpot`.
*   **Visualization**: Represents raw movement angles over time in seconds.

#### 2. History
*   **Source**: The `movement_history` field in Firestore.
*   **Transformation**: `convertHistory()` uses the list index for the X-axis and the `rom` (Range of Motion) value for the Y-axis.
*   **Labels**: The `date` field from each entry is used to generate the bottom titles of the chart.
*   **Visualization**: Tracks the progress of Range of Motion over multiple sessions/days.

### Usage

To use this widget, simply include it in your widget tree:

```dart
import 'package:medical_dashboard/Widgets/custom_line_chart.dart';

// Inside a build method
const CustomLineChart()
```

### UI Components

*   **`buildChartCard`**: A helper method that wraps each chart in a consistent container with a title, border, and axis labels.
*   **Dynamic Scaling**: The X-axis maximum for the Today chart is dynamically calculated based on the fetched data to ensure all points are visible.
