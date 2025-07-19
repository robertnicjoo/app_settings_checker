# App Settings Checker

**A Flutter plugin to check common device settings and open system settings menus.**  
By **PT. Nicxon International Solutions**

---

## 📚 Table of Contents

- [Installation](#-installation)
- [Platform Setup](#-platform-setup)
    - [Android](#android)
    - [iOS](#ios)
- [Usage](#-usage)
    - [Open App Settings](#open-app-settings)
    - [Location Settings](#location-settings)
    - [Notification Settings](#notification-settings)
    - [Battery Optimization Status](#battery-optimization-status)
    - [Battery Optimization Settings](#battery-optimization-settings)
    - [App Info & Device Details](#app-info--device-details)

---

## 🚀 Installation

Add the plugin to your project:

```bash
flutter pub add app_settings_checker
```

---

## 📱 Platform Setup

### Android

#### Required Permissions

Add the necessary permissions to your `AndroidManifest.xml` based on your usage:

##### 🔋 Battery Optimizations

```xml
<uses-permission android:name="android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS" />
```

##### 📍 Location Access

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

##### 🆔 Device ID (for `Build.SERIAL` on Android < 10)

```xml
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
```

---

### iOS

#### 📍 Location Services

Add the following key(s) to your `Info.plist` to request location permission from the user:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Need location access to check GPS settings.</string>
```
You can also add `NSLocationAlwaysUsageDescription` if your app requires background location.

#### 🆔 Device ID

> iOS does not allow permanent device IDs like Android’s `ANDROID_ID`.  
> The plugin uses `identifierForVendor`, which resets on uninstall/reinstall.

---

## 🧩 Usage

Import the package:

```dart
import 'package:app_settings_checker/app_settings_checker.dart';
```

---

### Open App Settings

```dart
AppSettingsChecker.openAppSettings();
```

---

### Location Settings

Check if location is enabled:

```dart
final isEnabled = await AppSettingsChecker.isLocationEnabled();
```

Open location settings (note: on iOS, this opens the app's settings page, not system location settings):

```dart
AppSettingsChecker.openLocationSettings();
```

---

### Notification Settings

Check if notifications are enabled:

```dart
final isEnabled = await AppSettingsChecker.areNotificationsEnabled();
```

Open notification settings:

```dart
AppSettingsChecker.openNotificationSettings();
```

---

### Battery Optimization Status

Check a more descriptive status using the BatteryOptimizationStatus enum:

```dart
final status = await AppSettingsChecker.getBatteryOptimizationStatus();

switch (status) {
  case BatteryOptimizationStatus.optimized:
    print('Battery optimization is ON for this app.');
    break;
  case BatteryOptimizationStatus.notOptimized:
    print('Battery optimization is OFF (whitelisted).');
    break;
  case BatteryOptimizationStatus.unknown:
    print('Battery optimization status unknown.');
    break;
}
```

No need to compare strings — you get type-safe values:

- `BatteryOptimizationStatus.optimized`
- `BatteryOptimizationStatus.notOptimized`
- `BatteryOptimizationStatus.unknown`

---

### Battery Optimization Settings

Check if battery optimization is disabled (Android only, not applicable on iOS):

```dart
final isDisabled = await AppSettingsChecker.isBatteryOptimizationDisabled();
```

Open battery optimization settings:

```dart
AppSettingsChecker.openBatteryOptimizationSettings();
```

---

### App Info & Device Details

Get app version:

```dart
final version = await AppSettingsChecker.getAppVersion();
```

Get phone model:

```dart
final model = await AppSettingsChecker.getPhoneModel();
```

Get device ID:

```dart
final deviceId = await AppSettingsChecker.getDeviceId();
```

Get Platform Version

```agsl
final platformVersion = await AppSettingsChecker.getPlatformVersion();
```

---