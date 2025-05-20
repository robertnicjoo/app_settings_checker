import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

/// A utility class to check and manage various app-related settings
/// on the device using platform channels.
class AppSettingsChecker {
  /// Method channel to communicate with the native platform (Android/iOS).
  static const MethodChannel _channel = MethodChannel('app_settings_checker');

  /// Checks if battery optimization is disabled for the app (Android only).
  /// Returns `true` if disabled, `false` otherwise.
  static Future<bool> isBatteryOptimizationDisabled() async {
    if (!Platform.isAndroid) return false;
    final bool result = await _channel.invokeMethod(
      'isBatteryOptimizationDisabled',
    );
    return result;
  }

  /// Opens the battery optimization settings screen (Android only).
  static Future<void> openBatteryOptimizationSettings() async {
    if (!Platform.isAndroid) return;
    await _channel.invokeMethod('openBatteryOptimizationSettings');
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
    if (!Platform.isAndroid) {
      // iOS always allows unless user disables explicitly in settings
      return true;
    }
    final bool result = await _channel.invokeMethod('areNotificationsEnabled');
    return result;
  }

  /// Opens the notification settings screen for the app (Android only).
  static Future<void> openNotificationSettings() async {
    if (!Platform.isAndroid) return;
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
