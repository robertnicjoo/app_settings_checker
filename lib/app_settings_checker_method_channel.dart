import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'app_settings_checker_platform_interface.dart';

/// An implementation of [AppSettingsCheckerPlatform] that uses method channels.
class MethodChannelAppSettingsChecker extends AppSettingsCheckerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('app_settings_checker');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
