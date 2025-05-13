import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_settings_checker/app_settings_checker_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelAppSettingsChecker platform = MethodChannelAppSettingsChecker();
  const MethodChannel channel = MethodChannel('app_settings_checker');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          return '42';
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
