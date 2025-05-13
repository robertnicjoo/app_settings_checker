import 'package:app_settings_checker/app_settings_checker.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "App Settings Checker", home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _platformVersion = 'Unknown';
  final _batteryOptimizationCheckerPlugin = AppSettingsChecker();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _batteryOptimizationCheckerPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> checkBatteryOptimization(BuildContext context) async {
    final isDisabled = await AppSettingsChecker.isBatteryOptimizationDisabled();
    if (!isDisabled) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text('Battery Optimization'),
              content: Text(
                'To ensure background tasks work reliably, please disable battery optimization for this app.',
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text('Open Settings'),
                  onPressed: () {
                    Navigator.pop(context);
                    AppSettingsChecker.openBatteryOptimizationSettings();
                  },
                ),
              ],
            ),
      );
    }
  }

  void checkLocationAndPrompt(BuildContext context) async {
    final isEnabled = await AppSettingsChecker.isLocationEnabled();
    print('isEnabled $isEnabled');
    if (!isEnabled) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text("Location Disabled"),
              content: Text(
                "Please enable location services for best experience.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    AppSettingsChecker.openLocationSettings();
                  },
                  child: Text("Open Settings"),
                ),
              ],
            ),
      );
    }
  }

  void checkNotificationsAndPrompt(BuildContext context) async {
    final areEnabled = await AppSettingsChecker.areNotificationsEnabled();
    if (!areEnabled) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("Notifications Disabled"),
              content: const Text(
                "To receive important updates, please enable notifications.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    AppSettingsChecker.openNotificationSettings();
                  },
                  child: const Text("Open Settings"),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Settings Checker Plugin')),
      body: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => checkBatteryOptimization(context),
            child: Text('Battery Optimization'),
          ),
          ElevatedButton(
            onPressed: () => checkNotificationsAndPrompt(context),
            child: Text('Notifications'),
          ),
          ElevatedButton(
            onPressed: () => checkLocationAndPrompt(context),
            child: Text('Location'),
          ),
          ElevatedButton(
            onPressed: () => AppSettingsChecker.openAppSettings(),
            child: Text('App Settings'),
          ),
          Center(child: Text('Running on: $_platformVersion')),
          FutureBuilder(
            future: AppSettingsChecker.getAppVersion(),
            builder: (context, snapshot) {
              return Text('App Version: ${snapshot.data ?? "Unknown"}');
            },
          ),
          FutureBuilder(
            future: AppSettingsChecker.getPhoneModel(),
            builder: (context, snapshot) {
              return Text('Phone Model: ${snapshot.data ?? "Unknown"}');
            },
          ),
          FutureBuilder(
            future: AppSettingsChecker.getDeviceId(),
            builder: (context, snapshot) {
              return Text('Decive ID: ${snapshot.data ?? "Unknown"}');
            },
          ),
        ],
      ),
    );
  }
}
