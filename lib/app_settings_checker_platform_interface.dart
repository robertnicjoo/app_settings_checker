import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'app_settings_checker_method_channel.dart';

abstract class AppSettingsCheckerPlatform extends PlatformInterface {
  /// Constructs a AppSettingsCheckerPlatform.
  AppSettingsCheckerPlatform() : super(token: _token);

  static final Object _token = Object();

  static AppSettingsCheckerPlatform _instance = MethodChannelAppSettingsChecker();

  /// The default instance of [AppSettingsCheckerPlatform] to use.
  ///
  /// Defaults to [MethodChannelAppSettingsChecker].
  static AppSettingsCheckerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AppSettingsCheckerPlatform] when
  /// they register themselves.
  static set instance(AppSettingsCheckerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
