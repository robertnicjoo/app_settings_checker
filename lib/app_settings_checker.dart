import 'dart:async';
import 'platform_stub.dart'
    if (dart.library.io) 'platform_io.dart'
    if (dart.library.html) 'platform_web.dart';
import 'package:flutter/services.dart';

import 'app_settings_checker_platform_interface.dart';

/// Represents the battery optimization status of the app on Android.
///
/// Used to indicate whether the app is currently affected by system-level
/// battery-saving features like Doze mode.
enum BatteryOptimizationStatus {
  /// The app is subject to battery optimizations.
  ///
  /// This is the default state. The system may restrict background activities
  /// such as alarms, jobs, and network access to conserve battery.
  optimized,

  /// The app is excluded from battery optimizations.
  ///
  /// The user has explicitly whitelisted the app, allowing it to bypass Doze mode
  /// and continue background activity without restrictions.
  notOptimized,

  /// The optimization status could not be determined.
  ///
  /// This may occur on platforms that do not support battery optimizations (e.g., Android versions below 6.0)
  /// or if an error occurs when querying the system.
  unknown,
}

/// Parses a string returned from the native platform into a [BatteryOptimizationStatus] enum.
///
/// - `'optimized'` → [BatteryOptimizationStatus.optimized]
/// - `'not_optimized'` → [BatteryOptimizationStatus.notOptimized]
/// - Any other value → [BatteryOptimizationStatus.unknown]
BatteryOptimizationStatus parseBatteryOptimizationStatus(String? value) {
  switch (value?.toLowerCase()) {
    case 'optimized':
      return BatteryOptimizationStatus.optimized;
    case 'not_optimized':
      return BatteryOptimizationStatus.notOptimized;
    default:
      return BatteryOptimizationStatus.unknown;
  }
}

/// A utility class to check and manage various app-related settings
/// on the device using platform channels.
class AppSettingsChecker {
  /// Method channel to communicate with the native platform (Android/iOS).
  static const MethodChannel _channel = MethodChannel('app_settings_checker');

  /// Checks if battery optimization is disabled for the app (Android only).
  /// Returns `true` if disabled, `false` otherwise.
  static Future<bool> isBatteryOptimizationDisabled() async {
    if (!isAndroid) return false;

    return AppSettingsCheckerPlatform.instance.isBatteryOptimizationDisabled();
  }

  /// Opens the battery optimization settings screen (Android only).
  static Future<void> openBatteryOptimizationSettings() async {
    if (!isAndroid) return;
    await _channel.invokeMethod('openBatteryOptimizationSettings');
  }

  /// Retrieves the current battery optimization status for the app (Android only).
  ///
  /// Returns one of:
  /// - [BatteryOptimizationStatus.optimized]
  /// - [BatteryOptimizationStatus.notOptimized]
  /// - [BatteryOptimizationStatus.unknown]
  static Future<BatteryOptimizationStatus> getBatteryOptimizationStatus() {
    return AppSettingsCheckerPlatform.instance.getBatteryOptimizationStatus();
  }

  /// Checks if location services are enabled on the device.
  /// Works on both Android and iOS.
  static Future<bool> isLocationEnabled() async {
    final bool result = await _channel.invokeMethod('isLocationEnabled');
    return result;
  }

  /// Opens the location settings screen to allow the user to enable/disable location.
  static Future<void> openLocationSettings() async {
    await _channel.invokeMethod('openLocationSettings');
  }

  /// Checks if notifications are enabled for the app.
  /// On iOS, always returns `true` unless explicitly disabled by the user.
  static Future<bool> areNotificationsEnabled() async {
    if (!isAndroid) {
      // iOS always allows unless user disables explicitly in settings
      return true;
    }
    final bool result = await _channel.invokeMethod('areNotificationsEnabled');
    return result;
  }

  /// Opens the notification settings screen for the app (Android only).
  static Future<void> openNotificationSettings() async {
    if (!isAndroid) return;
    await _channel.invokeMethod('openNotificationSettings');
  }

  /// Opens the general app settings screen.
  /// Works on both Android and iOS.
  static Future<void> openAppSettings() async {
    await _channel.invokeMethod('openAppSettings');
  }

  /// Retrieves the app version as a string.
  static Future<String?> getAppVersion() async {
    return await _channel.invokeMethod<String>('getAppVersion');
  }

  /// Retrieves the OS version running on the device.
  static Future<String?> getPlatformVersion() async {
    return await _channel.invokeMethod<String>('getPlatformVersion');
  }

  /// Retrieves the phone model name.
  static Future<String?> getPhoneModel() async {
    return await _channel.invokeMethod<String>('getPhoneModel');
  }

  /// Retrieves the device ID, usually a unique identifier.
  static Future<String?> getDeviceId() async {
    return await _channel.invokeMethod<String>('getDeviceId');
  }
}
