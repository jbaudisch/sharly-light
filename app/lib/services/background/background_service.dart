import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharly_app_light/constants.dart';
import 'package:sharly_app_light/services/background/notification_service.dart';
import 'package:sharly_app_light/utilities/platform.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';


const _activityIndexServiceName = "activity_index_notification_service";
const _deviceIdentifierKey = "deviceIdentifier";

/// Initialized the background service. Only has an effect on Android and iOS.
Future<void> initializeService() async {
  if (!isAndroid && !isIOS) return; // Return if not an Android or IOS

  final sharedPreferences = await SharedPreferences.getInstance();

  if (!sharedPreferences.containsKey(_deviceIdentifierKey)) {
    await sharedPreferences.setString(_deviceIdentifierKey, const Uuid().v4());
  }

  final clientIdentifier = sharedPreferences.getString(_deviceIdentifierKey)!;

  final service = FlutterBackgroundService();
  Workmanager().cancelAll();

  if (await service.isRunning()) {
    service.invoke("stop");
  }

  final inputData = {"clientIdentifier": clientIdentifier};

  if (continuousBackgroundService) {
    Workmanager().cancelAll();

    const channelId = "background_service";

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId, // id
      "Notification service", // title
      description: "Notifications", // description
      importance: Importance.low, // importance must be at low or higher level
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
        androidConfiguration: AndroidConfiguration(
            onStart: continuousService,
            initialNotificationTitle: "Listening for Notifications",
            initialNotificationContent: "Listening for Notifications",
            isForegroundMode: true,
            notificationChannelId: channelId),
        iosConfiguration: IosConfiguration());
    await service.startService();
    service.invoke("start", inputData);
  } else {
    Workmanager().initialize(_periodicService, isInDebugMode: kDebugMode);
    Workmanager().registerPeriodicTask(
        _activityIndexServiceName, _activityIndexServiceName,
        constraints: Constraints(networkType: NetworkType.connected),
        frequency: const Duration(minutes: 1),
        inputData: inputData,
        existingWorkPolicy: ExistingWorkPolicy.replace);
  }
}

/// Executes the periodic task configured in [initializeService]. This is not
/// meant to be called manually.
@pragma("vm:entry-point")
void _periodicService() =>
    Workmanager().executeTask((taskName, inputData) async {
      final clientIdentifier = inputData?["clientIdentifier"];
      if (clientIdentifier == null) {
        return false;
      }

      final service = BackgroundNotificationService(
          clientIdentifier: clientIdentifier,
      );
      await service.run(const Duration(seconds: 10));
      return true;
    });

@pragma('vm:entry-point')
void continuousService(ServiceInstance instance) async {
  DartPluginRegistrant.ensureInitialized();

  BackgroundNotificationService? service;

  instance.on("start").listen((event) async {
    final clientIdentifier = event?["clientIdentifier"];
    if (clientIdentifier == null) {
      debugPrint("No client identifier");
      return;
    }
    if (service != null) {
      debugPrint("Service has already started, restarting....");
      service?.stop();
    }
    service = BackgroundNotificationService(
        instance: instance,
        clientIdentifier: clientIdentifier);
    debugPrint("Starting service");
    service?.start();
  });

  instance.on("stop").listen((event) async {
    service?.stop();
    await instance.stopSelf();
  });
}