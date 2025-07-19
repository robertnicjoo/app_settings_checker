# Changelog

## [1.0.5]
- Added platform fallback with `platform_stub.dart`, using conditional imports for `dart:io` and `dart:html`.
- Improved platform detection for better web/wasm compatibility (returns safe defaults on unsupported platforms).
- Reduced runtime errors on non-mobile platforms (e.g., web, macOS, or wasm).
- Cleaned up imports and improved internal structuring.

## [1.0.4]
- Added new `BatteryOptimizationStatus` enum for safer, clearer status handling.
- Introduced `getBatteryOptimizationStatus()` method for detailed status.
- Improved documentation comments across platform interfaces and methods.
- Updated README with usage examples and enum-based status handling.

## [1.0.3]
- Improvement of API documents

## [1.0.2]
- Updated example code
- Added ios support

## [1.0.1]
- Added API Documentation

## [1.0.0]
- Initial release of the package with the following features:
    - Battery optimization status check.
    - Open battery optimization settings.
    - Location settings check and open location settings.
    - Notification settings check and open notification settings.
    - App version retrieval.
    - Access settings.
    - Phone model retrieval.
    - Device ID retrieval.


