# GPS Location Tracker (Android & iOS)

A professional Flutter application that continuously tracks and records the device's GPS location every 60 seconds, even in the background and after app force-kills. The project features deep native platform integration to display real-time battery percentage without using third-party battery packages.

## 🚀 Features

### 📍 Location Tracking
- **Continuous Background Tracking**: Records GPS coordinates (Latitude & Longitude) every 60 seconds.
- **Persistence**: Continues tracking when the app is backgrounded, minimized, the screen is locked, or even after the app is force-killed/swiped away (Android).
- **Auto-Resume**: Tracking automatically resumes after a device reboot if it was previously active.
- **Local Storage**: Data is saved locally using a process-safe SQLite database (`sqflite`).
- **History View**: Review recorded locations with timestamp and accuracy data in a clean, scrollable list.

### 🔋 Native Battery Display
- **Platform Channels**: Implemented using native **Kotlin** (Android) and **Swift** (iOS).
- **Zero Dependencies**: Strictly adheres to the requirement of not using external battery libraries.
- **Periodic Updates**: The battery percentage on the home screen updates every minute.

---

## 🛠️ Technical Implementation

### Android (Kotlin)
- **Foreground Service**: Uses `flutter_background_service` with a persistent notification.
- **Persistence**: Configured with `stopWithTask="false"` and `RECEIVE_BOOT_COMPLETED` to survive task manager kills and device restarts.
- **Native Battery**: Integrated via `MethodChannel` using `BatteryManager` in `MainActivity.kt`.
- **Target SDK**: Compiled against **Android SDK 34** with support for Android 12+ (Samsung/Pixel).

### iOS (Swift)
- **Background Modes**: Configured with `location` and `fetch` capabilities in `Info.plist`.
- **Privacy Permissions**: Fully implemented `NSLocationAlwaysAndWhenInUseUsageDescription` and `NSLocationAlwaysUsageDescription` for high-reliability background access.
- **Native Battery**: Integrated via `AppDelegate.swift` using `UIDevice.current.batteryLevel`.
- **Battery Monitoring**: Programmatically enables `isBatteryMonitoringEnabled` to ensure real-time accuracy.

### Database (SQLite)
- **Schema**:
  - `locations`: Stores `latitude`, `longitude`, `timestamp`, and `accuracy`.
  - `settings`: Persists the tracking state (ON/OFF) to ensure survival across reboots and app restarts.

---

## 📥 Installation & Setup

### Prerequisites
- **Flutter SDK**: 3.13.5+
- **Android**: Android Studio with Java 17 and SDK 34.
- **iOS**: macOS with Xcode 15+ and CocoaPods.

### Steps
1. **Clone the project**
2. **Sync dependencies**:
   ```bash
   flutter pub get
   ```
3. **Android Setup**: Ensure `local.properties` points to your Android SDK.
4. **iOS Setup**: 
   ```bash
   cd ios
   pod install
   cd ..
   ```
5. **Run the application**:
   ```bash
   flutter run
   ```

---

## 🧪 How to Test

### Android
1. **Start**: Tap **START**. Grant **Notification** and **Location** permissions.
2. **Background**: Minimize the app; notice the persistent notification.
3. **Kill**: Swipe the app away from "Recent Apps". The notification remains/restarts, and recording continues.
4. **Reboot**: Restart the phone; tracking resumes automatically based on the last saved state.

### iOS
1. **Start**: Tap **START**. When prompted, select **"Allow While Using App"**.
2. **Background Elevation**: Minimize the app. iOS will eventually prompt you to **"Change to Always Allow"** for background tracking—accept this for continuous recording.
3. **History**: Re-open the app to see coordinates captured while the screen was locked.

---

## ⚠️ Important Platform Notes
- **Android (Samsung/Pixel)**: To prevent OS throttling, go to **App Info > Battery > Unrestricted**. Change Location permission to **"Allow all the time"**.
- **iOS Simulator**: Battery level on the simulator often returns "Unknown" (-1%). For battery testing, a physical iPhone is recommended.
