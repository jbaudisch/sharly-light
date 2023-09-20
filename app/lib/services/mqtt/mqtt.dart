import 'package:mqtt_client/mqtt_client.dart';

import 'mqtt_stub.dart'
// import the implementation suitable for the target platform.
    if (dart.library.io) 'mqtt_native.dart'
    if (dart.library.js) 'mqtt_web.dart';

abstract class MqttClientFactory {
  MqttClient create(
    String server,
    String clientIdentifier, {
    maxConnectionAttempts = 3,
  });

  MqttClient createWithPort(
    String server,
    String clientIdentifier,
    int port, {
    maxConnectionAttempts = 3,
  });
}

abstract class AdaptiveMqttClient {
  static final _factory = getMqttClientFactory();

  /// Returns a platform appropriate [MqttClient] using [server], [clientIdentifier]
  /// and [maxConnectionAttempts].
  static MqttClient withoutPort(String server, String clientIdentifier,
          {maxConnectionAttempts = 3}) =>
      _factory.create(server, clientIdentifier,
          maxConnectionAttempts: maxConnectionAttempts);

  /// Returns a platform appropriate [MqttClient] using [server], [clientIdentifier]
  /// [port] and [maxConnectionAttempts].
  static MqttClient withPort(String server, String clientIdentifier, int port,
          {maxConnectionAttempts = 3}) =>
      _factory.createWithPort(server, clientIdentifier, port,
          maxConnectionAttempts: maxConnectionAttempts);
}
