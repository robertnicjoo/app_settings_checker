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
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.red,
        scaffoldBackgroundColor: Colors.blueGrey.shade50,
        appBarTheme: AppBarTheme(backgroundColor: Colors.blueGrey.shade50),
      ),
      title: "App Settings Checker",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _platformVersion = 'Unknown';

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
          await AppSettingsChecker.getPlatformVersion() ??
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
    if (context.mounted && !isDisabled) {
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
    if (context.mounted && !isEnabled) {
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
    if (context.mounted && isEnabled) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text("Location Enabled"),
              content: Text("Location is already enabled."),
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
    if (context.mounted && !areEnabled) {
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

  void showBatteryOptimizationStatus(BuildContext context) async {
    final status = await AppSettingsChecker.getBatteryOptimizationStatus();

    if (!context.mounted) return;

    String message;
    switch (status) {
      case BatteryOptimizationStatus.notOptimized:
        message = 'Battery optimization is turned off for this app.';
        break;
      case BatteryOptimizationStatus.optimized:
        message = 'Battery optimization is ON for this app.';
        break;
      case BatteryOptimizationStatus.unknown:
        message = 'Could not determine the battery optimization status.';
        break;
    }

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Battery Optimization Status'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  AppSettingsChecker.openBatteryOptimizationSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Settings Checker Plugin')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 300,
          ), // max width for all buttons
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // makes buttons fill width
            children: [
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => checkBatteryOptimization(context),
                child: const Text('Battery Optimization'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => showBatteryOptimizationStatus(context),
                child: const Text('Battery Optimization Status'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => checkNotificationsAndPrompt(context),
                child: const Text('Notifications'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => checkLocationAndPrompt(context),
                child: const Text('Location'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => AppSettingsChecker.openAppSettings(),
                child: const Text('App Settings'),
              ),
              const SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  text: 'Running on: ',
                  children: [
                    TextSpan(
                      text: _platformVersion,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 10),
              FutureBuilder(
                future: AppSettingsChecker.getAppVersion(),
                builder: (context, snapshot) {
                  return Text.rich(
                    TextSpan(
                      text: 'App Version: ',
                      children: [
                        TextSpan(
                          text: snapshot.data ?? "Unknown",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  );
                },
              ),
              const SizedBox(height: 10),
              FutureBuilder(
                future: AppSettingsChecker.getPhoneModel(),
                builder: (context, snapshot) {
                  return Text.rich(
                    TextSpan(
                      text: 'Phone Model: ',
                      children: [
                        TextSpan(
                          text: snapshot.data ?? "Unknown",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  );
                },
              ),
              const SizedBox(height: 10),
              FutureBuilder(
                future: AppSettingsChecker.getDeviceId(),
                builder: (context, snapshot) {
                  return Text.rich(
                    TextSpan(
                      text: 'Device ID: ',
                      children: [
                        TextSpan(
                          text: snapshot.data ?? "Unknown",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
