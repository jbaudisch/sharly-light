import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

import 'mqtt.dart';

MqttClientFactory getMqttClientFactory() => WebMqttClientFactory();

/// Implementation of [MqttClientFactory] for web.
class WebMqttClientFactory extends MqttClientFactory {
  @override
  MqttClient create(String server, String clientIdentifier,
      {maxConnectionAttempts = 3}) {
    return MqttBrowserClient(server, clientIdentifier,
        maxConnectionAttempts: maxConnectionAttempts);
  }

  @override
  MqttClient createWithPort(String server, String clientIdentifier, int port,
      {maxConnectionAttempts = 3}) {
    return MqttBrowserClient.withPort(server, clientIdentifier, port,
        maxConnectionAttempts: maxConnectionAttempts);
  }
}
