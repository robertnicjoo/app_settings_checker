import 'dart:async';
import 'app_settings_checker_platform_interface.dart';
import 'package:flutter/services.dart';

class AppSettingsChecker {
  static const MethodChannel _channel = MethodChannel('app_settings_checker');

  static Future<bool> isBatteryOptimizationDisabled() async {
    final bool result = await _channel.invokeMethod(
      'isBatteryOptimizationDisabled',
    );
    return result;
  }

  static Future<void> openBatteryOptimizationSettings() async {
    await _channel.invokeMethod('openBatteryOptimizationSettings');
  }

  static Future<bool> isLocationEnabled() async {
    final bool result = await _channel.invokeMethod('isLocationEnabled');
    return result;
  }

  static Future<void> openLocationSettings() async {
    await _channel.invokeMethod('openLocationSettings');
  }

  static Future<bool> areNotificationsEnabled() async {
    final bool result = await _channel.invokeMethod('areNotificationsEnabled');
    return result;
  }

  static Future<void> openNotificationSettings() async {
    await _channel.invokeMethod('openNotificationSettings');
  }

  static Future<void> openAppSettings() async {
    await _channel.invokeMethod('openAppSettings');
  }

  static Future<String?> getAppVersion() async {
    return await _channel.invokeMethod<String>('getAppVersion');
  }

  Future<String?> getPlatformVersion() {
    return AppSettingsCheckerPlatform.instance.getPlatformVersion();
  }

  static Future<String?> getPhoneModel() async {
    return await _channel.invokeMethod<String>('getPhoneModel');
  }

  static Future<String?> getDeviceId() async {
    return await _channel.invokeMethod<String>('getDeviceId');
  }
}
