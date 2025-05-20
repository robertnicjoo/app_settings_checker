import Flutter
import UIKit
import CoreLocation
import UserNotifications

public class AppSettingsCheckerPlugin: NSObject, FlutterPlugin {
  let locationManager = CLLocationManager()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "app_settings_checker", binaryMessenger: registrar.messenger())
    let instance = AppSettingsCheckerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {

    case "openSettings", "openAppSettings":
      if let url = URL(string: UIApplication.openSettingsURLString) {
        if UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
          result(nil)
        } else {
          result(FlutterError(code: "UNAVAILABLE", message: "Cannot open settings", details: nil))
        }
      }

    case "areNotificationsEnabled":
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        DispatchQueue.main.async {
          result(settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional)
        }
      }

    case "openNotificationSettings":
      if let url = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        result(nil)
      } else {
        result(FlutterError(code: "UNAVAILABLE", message: "Cannot open settings", details: nil))
      }

    case "isLocationEnabled":
      let status = CLLocationManager.authorizationStatus()
      let enabled = CLLocationManager.locationServicesEnabled() &&
                    (status == .authorizedAlways || status == .authorizedWhenInUse)
      result(enabled)

    case "openLocationSettings":
      if let url = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        result(nil)
      } else {
        result(FlutterError(code: "UNAVAILABLE", message: "Cannot open settings", details: nil))
      }

    case "getAppVersion":
      if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        result(version)
      } else {
        result(FlutterError(code: "VERSION_ERROR", message: "Cannot get app version", details: nil))
      }

    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)

    case "getPhoneModel":
      result(UIDevice.current.model + " " + UIDevice.current.systemName)

    case "getDeviceId":
      result(UIDevice.current.identifierForVendor?.uuidString)

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
