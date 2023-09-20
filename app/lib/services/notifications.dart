import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sharly_app_light/models/activity_index.dart';
import 'package:sharly_app_light/models/notification_payload/notification_payload.dart';
import 'package:sharly_app_light/screens/activity_index.dart';
import 'package:sharly_app_light/utilities/global_navigator_state.dart';


/// Initializes the notifications plugin. This is necessary for notifications to
/// work.
Future<void> initializeNotifications() async {
  final notificationPlugin = FlutterLocalNotificationsPlugin();
  notificationPlugin.initialize(
      const InitializationSettings(
          android: AndroidInitializationSettings("@mipmap/ic_launcher")),
      onDidReceiveNotificationResponse: _notificationTapBackground);
}

@pragma("vm:entry-point")
void _notificationTapBackground(NotificationResponse response) {
  if (globalNavigatorKey.currentContext == null || response.payload == null) {
    return;
  }
  final payload = NotificationPayload.fromJson(jsonDecode(response.payload!));
  final screen = screenFromNotificationPayload(payload);
  if (screen == null) return;
  Navigator.of(globalNavigatorKey.currentContext!)
      .push(MaterialPageRoute(builder: (context) => screen));
}

Widget? screenFromNotificationPayload(NotificationPayload payload) =>
    switch (payload.type) {
      NotificationPayloadType.activityIndex =>
          ActivityIndexScreen(index: ActivityIndex.fromValue(payload.content))
    };
