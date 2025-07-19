import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'app_settings_checker.dart';
import 'app_settings_checker_method_channel.dart';

/// Abstract class representing the platform interface for the AppSettingsChecker plugin.
abstract class AppSettingsCheckerPlatform extends PlatformInterface {
  /// Constructs a [AppSettingsCheckerPlatform].
  AppSettingsCheckerPlatform() : super(token: _token);

  // A token used to verify the platform implementation.
  static final Object _token = Object();

  // The default instance of [AppSettingsCheckerPlatform]. Initially set to the MethodChannel implementation.
  static AppSettingsCheckerPlatform _instance =
      MethodChannelAppSettingsChecker();

  /// The default instance of [AppSettingsCheckerPlatform] to use.
  ///
  /// By default, this will return an instance of [MethodChannelAppSettingsChecker].
  static AppSettingsCheckerPlatform get instance => _instance;

  /// Sets the instance of [AppSettingsCheckerPlatform] to use.
  /// Platform-specific implementations should assign their own class that extends [AppSettingsCheckerPlatform].
  ///
  /// This is typically called during plugin registration to bind platform-specific logic.
  static set instance(AppSettingsCheckerPlatform instance) {
    PlatformInterface.verifyToken(
      instance,
      _token,
    ); // Verifies that the instance is using the correct token.
    _instance = instance;
  }

  /// An abstract method that platform-specific implementations must implement.
  /// This method is used to retrieve the platform version (e.g., Android version or iOS version).
  Future<String?> getPlatformVersion() {
    // This method should be implemented by platform-specific code.
    throw UnimplementedError('getPlatformVersion() has not been implemented.');
  }

  /// Checks whether battery optimization is disabled for the app.
  ///
  /// Returns `true` if the app is excluded from battery optimization (e.g., the system is ignoring optimizations),
  /// and `false` if the app is still subject to Doze mode and other battery-saving behaviors.
  ///
  /// Only meaningful on Android 6.0+ (API level 23+). Other platforms should return `false` or handle appropriately.
  Future<bool> isBatteryOptimizationDisabled();

  /// Retrieves the current battery optimization status for the app (Android only).
  ///
  /// Returns a [BatteryOptimizationStatus] enum value representing whether the app is:
  /// - [BatteryOptimizationStatus.notOptimized]: Excluded from battery optimizations (user has whitelisted the app).
  /// - [BatteryOptimizationStatus.optimized]: Subject to battery optimizations (default behavior).
  /// - [BatteryOptimizationStatus.unknown]: Status could not be determined (e.g., API level < 23 or unsupported platform).
  ///
  /// This provides a more descriptive and type-safe alternative to [isBatteryOptimizationDisabled].
  Future<BatteryOptimizationStatus> getBatteryOptimizationStatus();
}
