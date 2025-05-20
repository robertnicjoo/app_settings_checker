import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class AppSettingsChecker {
  static const MethodChannel _channel = MethodChannel('app_settings_checker');

  static Future<bool> isBatteryOptimizationDisabled() async {
    if (!Platform.isAndroid) return false;
    final bool result = await _channel.invokeMethod(
      'isBatteryOptimizationDisabled',
    );
    return result;
  }

  static Future<void> openBatteryOptimizationSettings() async {
    if (!Platform.isAndroid) return;
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
    if (!Platform.isAndroid)
      return true; // iOS always allows unless user disables explicitly in settings
    final bool result = await _channel.invokeMethod('areNotificationsEnabled');
    return result;
  }

  static Future<void> openNotificationSettings() async {
    if (!Platform.isAndroid) return;
    await _channel.invokeMethod('openNotificationSettings');
  }

  static Future<void> openAppSettings() async {
    await _channel.invokeMethod('openAppSettings');
  }

  static Future<String?> getAppVersion() async {
    return await _channel.invokeMethod<String>('getAppVersion');
  }

  static Future<String?> getPlatformVersion() async {
    return await _channel.invokeMethod<String>('getPlatformVersion');
  }

  static Future<String?> getPhoneModel() async {
    return await _channel.invokeMethod<String>('getPhoneModel');
  }

  static Future<String?> getDeviceId() async {
    return await _channel.invokeMethod<String>('getDeviceId');
  }
}
