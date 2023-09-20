import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'mqtt.dart';

MqttClientFactory getMqttClientFactory() => NativeMqttClientFactory();

/// Implementation of [MqttClientFactory] for native (e.g. Android, iOS, Windows)
class NativeMqttClientFactory extends MqttClientFactory {
  @override
  MqttClient create(String server, String clientIdentifier,
      {maxConnectionAttempts = 3}) {
    return MqttServerClient(server, clientIdentifier,
        maxConnectionAttempts: maxConnectionAttempts);
  }

  @override
  MqttClient createWithPort(String server, String clientIdentifier, int port,
      {maxConnectionAttempts = 3}) {
    return MqttServerClient.withPort(server, clientIdentifier, port,
        maxConnectionAttempts: maxConnectionAttempts);
  }
}
