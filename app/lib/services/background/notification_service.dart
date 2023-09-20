import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:sharly_app_light/constants.dart';
import 'package:sharly_app_light/utilities/notification_id.dart';
import 'package:sharly_app_light/models/activity_index.dart';
import 'package:sharly_app_light/models/notification_payload/notification_payload.dart';
import 'package:sharly_app_light/utilities/string_res.dart';

import '../mqtt/mqtt.dart';

/// Service which opens a persistent MQTT connection to a broker and sends
/// a notification if a new activity index is available.
class BackgroundNotificationService {
  /// Client identifier used by the MQTT Client. Should stay the same over
  /// various cycles so that the MQTT client can catch up missed messages.
  final String clientIdentifier;

  /// The [ServiceInstance] instance when the service is started using
  /// flutter_background_service
  final ServiceInstance? instance;

  static const _androidNotificationDetails = AndroidNotificationDetails(
      "activity_index", "Activity Index Notification",
      icon: "@mipmap/ic_launcher");

  static const _notificationDetails =
  NotificationDetails(android: _androidNotificationDetails);

  final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  late final _notificationHandlers = <String, Function(MqttPublishPayload)>{
    mqttTopic: (payload) async {
      final index = ActivityIndex.fromValue(utf8.decode(payload.message));
      final localizations = await sFromLocale(const Locale("en"));
      await _notificationsPlugin.show(
          NotificationId.newId,
          localizations.activityIndexMessageTitle,
          localizations.activityIndexMessageContent(index.title, index.emoji),
          _notificationDetails,
          payload: jsonEncode(NotificationPayload(
              type: NotificationPayloadType.activityIndex,
              content: index.title)));
    },
  };

  MqttClient? _mqttClient;

  BackgroundNotificationService(
      {this.instance,
        required this.clientIdentifier});

  /// Closes the MQTT connection and disposes the MQTT Client.
  void stop() {
    _mqttClient?.disconnect();
    _mqttClient = null;
  }

  /// Runs the service for [duration] and then stops it.
  Future<void> run(Duration duration) async {
    await start();
    await Future.delayed(duration);
    stop();
  }

  /// Starts the service.
  Future<void> start() async {
    _mqttClient =
        AdaptiveMqttClient.withPort(mqttHost, clientIdentifier, mqttPort);
    _mqttClient?.setProtocolV311();
    _mqttClient?.logging(on: kDebugMode);
    _mqttClient
      ?..autoReconnect = true
      ..keepAlivePeriod = 10
      ..resubscribeOnAutoReconnect = true;

    final connectMessage =
    MqttConnectMessage().withClientIdentifier(clientIdentifier);

    _mqttClient?.connectionMessage = connectMessage;
    _mqttClient?.onSubscribed = (s) {
      print("subscribed to $s");
    };
    _mqttClient?.onSubscribeFail = (e) {
      print("failed to subscribe to $e");
    };
    _mqttClient?.onDisconnected = () {
      print("disconnected from broker");
    };
    final status = await _mqttClient?.connect(mqttUsername, mqttPassword);
    _mqttClient?.updates!.listen((events) {
      for (var event in events) {
        _notificationHandlers[event.topic]
            ?.call((event.payload as MqttPublishMessage).payload);
      }
    });
    if (status?.state != MqttConnectionState.connected) {
      print("An error occurred while connecting to broker");
      _mqttClient = null;
      return;
    }
    for (var key in _notificationHandlers.keys) {
      _mqttClient?.subscribe(key, MqttQos.exactlyOnce);
    }
  }

  /// Closes the MQTT connection and opens a new one.
  Future<void> reconnect() async {
    stop();
    start();
  }
}
