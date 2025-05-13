import 'dart:async';
import 'app_settings_checker_platform_interface.dart';
import 'package:flutter/services.dart';

class AppSettingsChecker {
  // Create a MethodChannel for communicating with native code
  static const MethodChannel _channel = MethodChannel('app_settings_checker');

  // Checks if battery optimization is disabled for the app
  static Future<bool> isBatteryOptimizationDisabled() async {
    final bool result = await _channel.invokeMethod(
      'isBatteryOptimizationDisabled', // Native method to check battery optimization
    );
    return result;
  }

  // Opens the battery optimization settings page on the device
  static Future<void> openBatteryOptimizationSettings() async {
    await _channel.invokeMethod('openBatteryOptimizationSettings'); // Native method to open settings
  }

  // Checks if the location services are enabled on the device
  static Future<bool> isLocationEnabled() async {
    final bool result = await _channel.invokeMethod('isLocationEnabled'); // Native method to check location
    return result;
  }

  // Opens the location settings page on the device
  static Future<void> openLocationSettings() async {
    await _channel.invokeMethod('openLocationSettings'); // Native method to open location settings
  }

  // Checks if notifications are enabled for the app
  static Future<bool> areNotificationsEnabled() async {
    final bool result = await _channel.invokeMethod('areNotificationsEnabled'); // Native method to check notifications
    return result;
  }

  // Opens the notification settings page on the device
  static Future<void> openNotificationSettings() async {
    await _channel.invokeMethod('openNotificationSettings'); // Native method to open notification settings
  }

  // Opens the general app settings page on the device
  static Future<void> openAppSettings() async {
    await _channel.invokeMethod('openAppSettings'); // Native method to open app settings
  }

  // Retrieves the version of the app
  static Future<String?> getAppVersion() async {
    return await _channel.invokeMethod<String>('getAppVersion'); // Native method to get app version
  }

  // Retrieves the platform version (iOS/Android)
  Future<String?> getPlatformVersion() {
    return AppSettingsCheckerPlatform.instance.getPlatformVersion(); // Calls the platform-specific implementation
  }

  // Retrieves the phone model (e.g., "Pixel 4", "iPhone 11")
  static Future<String?> getPhoneModel() async {
    return await _channel.invokeMethod<String>('getPhoneModel'); // Native method to get phone model
  }

  // Retrieves a unique device ID (may be different based on platform and permissions)
  static Future<String?> getDeviceId() async {
    return await _channel.invokeMethod<String>('getDeviceId'); // Native method to get device ID
  }
}
