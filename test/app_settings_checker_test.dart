import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_settings_checker/app_settings_checker.dart';
import 'package:app_settings_checker/app_settings_checker_platform_interface.dart';
import 'package:app_settings_checker/app_settings_checker_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAppSettingsCheckerPlatform
    with MockPlatformInterfaceMixin
    implements AppSettingsCheckerPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> isBatteryOptimizationDisabled() => Future.value(false);

  @override
  Future<BatteryOptimizationStatus> getBatteryOptimizationStatus() =>
      Future.value(BatteryOptimizationStatus.optimized);
}

void main() {
  final AppSettingsCheckerPlatform initialPlatform =
      AppSettingsCheckerPlatform.instance;

  test('$MethodChannelAppSettingsChecker is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAppSettingsChecker>());
  });

  test('getPlatformVersion', () async {
    AppSettingsChecker _ = AppSettingsChecker();
    MockAppSettingsCheckerPlatform fakePlatform =
        MockAppSettingsCheckerPlatform();
    AppSettingsCheckerPlatform.instance = fakePlatform;

    expect(await AppSettingsChecker.getPlatformVersion(), '42');
  });
}
