import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'app_settings_checker.dart';
import 'app_settings_checker_platform_interface.dart';

/// An implementation of [AppSettingsCheckerPlatform] that uses method channels.
class MethodChannelAppSettingsChecker extends AppSettingsCheckerPlatform {
  /// The method channel used to interact with the native platform.
  /// This channel is used to call native methods from the platform-specific implementations (e.g., Android, iOS).
  @visibleForTesting
  final methodChannel = const MethodChannel('app_settings_checker');

  /// Retrieves the platform version (e.g., Android 10 or iOS 14).
  /// This method communicates with the native platform to fetch the version.
  @override
  Future<String?> getPlatformVersion() async {
    try {
      // Invoke the native method to get the platform version
      final version = await methodChannel.invokeMethod<String>(
        'getPlatformVersion',
      );
      return version;
    } on PlatformException catch (e) {
      // Handle any platform exception if the method fails
      throw 'Failed to get platform version: ${e.message}';
    }
  }

  /// Checks whether battery optimization is disabled for the app.
  ///
  /// Returns `true` if the app is excluded from battery optimization (i.e., the system is ignoring optimizations),
  /// and `false` if the app is still subject to Doze mode and other optimizations.
  ///
  /// Only available on Android 6.0+; always returns `false` on unsupported platforms.
  @override
  Future<bool> isBatteryOptimizationDisabled() async {
    final result = await methodChannel.invokeMethod<bool>(
      'isBatteryOptimizationDisabled',
    );
    return result ?? false;
  }

  /// Retrieves the current battery optimization status for the app.
  ///
  /// Returns a [BatteryOptimizationStatus] enum value:
  /// - [BatteryOptimizationStatus.notOptimized]: The app is excluded from battery optimization.
  /// - [BatteryOptimizationStatus.optimized]: The app is subject to battery optimization (default behavior).
  /// - [BatteryOptimizationStatus.unknown]: Status could not be determined (e.g., API < 23 or platform error).
  @override
  Future<BatteryOptimizationStatus> getBatteryOptimizationStatus() async {
    final result = await methodChannel.invokeMethod<String>(
      'getBatteryOptimizationStatus',
    );
    return parseBatteryOptimizationStatus(result ?? 'unknown');
  }
}
