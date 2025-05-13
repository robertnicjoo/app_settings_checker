import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
      final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
      return version;
    } on PlatformException catch (e) {
      // Handle any platform exception if the method fails
      throw 'Failed to get platform version: ${e.message}';
    }
  }
}
