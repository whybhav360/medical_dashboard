# Medical Dashboard 

A high-performance Flutter application designed for clinical monitoring and patient rehabilitation tracking. This project focuses on real-time biometric data visualization, cloud synchronization, and automated clinical reporting.

## 🏗 Architecture & Technical Overview

This project follows a modular UI-driven architecture, separating core widgets from page-level state management. It leverages **Google Firebase** for a serverless backend, ensuring low-latency data synchronization.

### Core Technical Pillars:
- **Real-time Data Pipeline**: Integration with **Cloud Firestore** using asynchronous streams to pipe biometric sensor data (Angle, ROM) directly into the UI.
- **Reactive Visualization**: Built with `fl_chart`, implementing custom touch handlers and dynamic scaling to handle high-frequency data points.
- **Hardware-Accelerated Reporting**: Utilizes `RepaintBoundary` to capture widget-level render objects and convert them into PDF format without loss of fidelity.

## 🛠 Tech Stack

| Layer | Technology | Purpose |
| :--- | :--- | :--- |
| **Frontend** | Flutter (Dart) | Cross-platform UI/UX rendering. |
| **Database** | Cloud Firestore | NoSQL real-time document storage for movement logs. |
| **Auth** | Firebase Auth | Secure patient/clinician session management. |
| **PDF Engine** | `pdf` & `printing` | Rendering rasterized widget trees into ISO-standard PDFs. |
| **Charts** | `fl_chart` | Canvas-based rendering for biometric trends. |

## 📊 Deep Dive: Real-time Graphing & Data

The dashboard implements a sophisticated data-to-chart pipeline:
1. **Firestore Hook**: The `CustomLineChart` component is designed to interface with a NoSQL document structure where `movement_today` (List of Map) and `movement_history` are stored.
2. **Data Transformation**: Raw Firestore maps are mapped to `FlSpot` objects. The Y-axis dynamically represents the **Range of Motion (ROM)** while the X-axis tracks **Time (S)** or **Date**.
3. **Optimized Rendering**: To maintain 60 FPS while rendering complex charts, the application uses local state caching to prevent unnecessary rebuilds of the entire widget tree during data updates.

## 📄 Clinical Report Generation

One of the standout features is the **Automated PDF Engine**:
- **Repaint Boundary Capture**: The application wraps the medical data grid and charts in a `RepaintBoundary`.
- **Render Object Conversion**: Using `boundary.toImage()`, the UI is converted into a high-density `Uint8List` image.
- **Document Assembly**: The `pdf` package then wraps these assets into a multi-page document, allowing clinicians to print or share reports directly from the mobile interface.

## 📦 Key Packages Used

- `firebase_core` & `firebase_auth`: Backend infrastructure.
- `cloud_firestore`: Real-time data synchronization.
- `fl_chart`: High-performance canvas-based charting.
- `path_provider`: Local file system access for PDF caching.
- `share_plus`: Native sharing intent for exported medical reports.
- `intl`: Localized date-time parsing for clinical logging.

## 🚀 Development & Setup

1. **Clone & Install**:

    ```bash
    git clone https://github.com/whybhav360/medical_dashboard.git
    cd medical_dashboard
    flutter pub get
    ```
​
2. **Firebase Configuration**:
   The project requires a `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) file.
   - Register your app in the Firebase Console.
   - Enable Email/Password Authentication and Cloud Firestore.
   - Use `flutterfire configure` to generate the `firebase_options.dart` file.
     ​
3. **Environment Secrets**:
   Ensure `lib/secrets.dart` is configured with the necessary document IDs or configuration strings used by the data fetchers.
   ​
4. **Run the Project**:
   ```bash
   flutter run
   ```
​
---
*Developed with a focus on scalability and clinical accuracy.*