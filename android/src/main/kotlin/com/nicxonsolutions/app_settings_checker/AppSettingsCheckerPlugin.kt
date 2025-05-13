package com.nicxonsolutions.app_settings_checker

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel.Result

class AppSettingsCheckerPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private var activity: Activity? = null
  private var context: Context? = null

  override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    context = binding.applicationContext
    channel = MethodChannel(binding.binaryMessenger, "app_settings_checker")
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    context = null
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    when (call.method) {
      "isBatteryOptimizationDisabled" -> {
        val ctx = context
        if (ctx == null) {
          result.error("NO_CONTEXT", "Context is null", null)
          return
        }
        val powerManager = ctx.getSystemService(Context.POWER_SERVICE) as PowerManager
        val isIgnoring = powerManager.isIgnoringBatteryOptimizations(ctx.packageName)
        result.success(isIgnoring)
      }

      "openBatteryOptimizationSettings" -> {
        val act = activity
        if (act == null) {
          result.error("NO_ACTIVITY", "Activity is null", null)
          return
        }

        val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
          data = Uri.parse("package:" + act.packageName)
        }

        act.startActivity(intent)
        result.success(null)
      }

      "areNotificationsEnabled" -> {
        val ctx = context
        if (ctx == null) {
          result.error("NO_CONTEXT", "Context is null", null)
          return
        }

        val notificationManagerCompat = androidx.core.app.NotificationManagerCompat.from(ctx)
        result.success(notificationManagerCompat.areNotificationsEnabled())
      }

      "openNotificationSettings" -> {
        val act = activity
        if (act == null) {
          result.error("NO_ACTIVITY", "Activity is null", null)
          return
        }

        val intent = Intent().apply {
          action = Settings.ACTION_APP_NOTIFICATION_SETTINGS
          putExtra(Settings.EXTRA_APP_PACKAGE, act.packageName)
        }
        act.startActivity(intent)
        result.success(null)
      }

      "isLocationEnabled" -> {
        val ctx = context
        if (ctx == null) {
          result.error("NO_CONTEXT", "Context is null", null)
          return
        }

        val locationManager = ctx.getSystemService(Context.LOCATION_SERVICE) as android.location.LocationManager
        val isEnabled = locationManager.isProviderEnabled(android.location.LocationManager.GPS_PROVIDER)
                || locationManager.isProviderEnabled(android.location.LocationManager.NETWORK_PROVIDER)
        result.success(isEnabled)
      }

      "openLocationSettings" -> {
        val act = activity
        if (act == null) {
          result.error("NO_ACTIVITY", "Activity is null", null)
          return
        }

        val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
        act.startActivity(intent)
        result.success(null)
      }

      "openAppSettings" -> {
        val act = activity
        if (act == null) {
          result.error("NO_ACTIVITY", "Activity is null", null)
          return
        }

        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
          data = Uri.fromParts("package", act.packageName, null)
        }
        act.startActivity(intent)
        result.success(null)
      }

      "getAppVersion" -> {
        val ctx = context
        if (ctx == null) {
          result.error("NO_CONTEXT", "Context is null", null)
          return
        }

        try {
          val packageInfo = ctx.packageManager.getPackageInfo(ctx.packageName, 0)
          result.success(packageInfo.versionName)
        } catch (e: Exception) {
          result.error("VERSION_ERROR", "Failed to get version", e.message)
        }
      }

      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }

      "getPhoneModel" -> {
        result.success("${Build.MANUFACTURER} ${Build.MODEL}")
      }

      "getDeviceId" -> {
        val ctx = context
        if (ctx == null) {
          result.error("NO_CONTEXT", "Context is null", null)
          return
        }
        val androidId = Settings.Secure.getString(ctx.contentResolver, Settings.Secure.ANDROID_ID)
        result.success(androidId)
      }

      else -> {
        result.notImplemented()
      }
    }
  }
}
