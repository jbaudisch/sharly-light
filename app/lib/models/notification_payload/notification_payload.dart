import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_payload.freezed.dart';
part 'notification_payload.g.dart';

/// Enum containing the different types of notification payloads.
@JsonEnum(valueField: "id")
enum NotificationPayloadType {
  activityIndex(0);

  final int id;

  const NotificationPayloadType(this.id);
}

/// Data class for the notification payload.
@freezed
class NotificationPayload with _$NotificationPayload {
  const factory NotificationPayload({
    required NotificationPayloadType type,
    required String content}) = _NotificationPayload;

  factory NotificationPayload.fromJson(Map<String, dynamic> json) =>
      _$NotificationPayloadFromJson(json);
}
