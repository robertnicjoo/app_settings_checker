# App Settings Checker

App Settings Checker By PT. Nicxon International Solutions


## Install

```agsl
flutter pub add app_settings_checker
```

## Permissions

Add following permissions to `AndroidManifest.xml` based on your usage

### Battery Optimizations

```agsl
<uses-permission android:name="android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS"/>
```

### Location

```agsl
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

### Device ID

For `Build.SERIAL` on `Android < 10` you need following permission

```agsl
<uses-permission android:name="android.permission.READ_PHONE_STATE"/>
```

## How to use

### Open App Settings

```agsl
AppSettingsChecker.openAppSettings()
```

### Open Location Settings

Check if location is enabled:
```agsl
AppSettingsChecker.isLocationEnabled()
```

Open location settings if it's disabled:

```agsl
AppSettingsChecker.openLocationSettings()
```

### Open Notification Settings

Check if notifications are enabled:

```agsl
AppSettingsChecker.areNotificationsEnabled()
```

Open notification settings if they're disabled:

```agsl
 AppSettingsChecker.openNotificationSettings()
```

### Open Battery Optimization Settings

Check if battery optimization is disabled:

```agsl
AppSettingsChecker.isBatteryOptimizationDisabled()
```

Open battery optimization settings if it's disabled:

```agsl
AppSettingsChecker.openBatteryOptimizationSettings()
```

### Get Platform version

```agsl
AppSettingsChecker.getAppVersion()
```

### Get Phone Model

```agsl
AppSettingsChecker.getPhoneModel()
```

### Get Device ID

```agsl
AppSettingsChecker.getDeviceId()
```