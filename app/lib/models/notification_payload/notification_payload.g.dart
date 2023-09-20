// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NotificationPayload _$$_NotificationPayloadFromJson(
        Map<String, dynamic> json) =>
    _$_NotificationPayload(
      type: $enumDecode(_$NotificationPayloadTypeEnumMap, json['type']),
      content: json['content'] as String,
    );

Map<String, dynamic> _$$_NotificationPayloadToJson(
        _$_NotificationPayload instance) =>
    <String, dynamic>{
      'type': _$NotificationPayloadTypeEnumMap[instance.type]!,
      'content': instance.content,
    };

const _$NotificationPayloadTypeEnumMap = {
  NotificationPayloadType.activityIndex: 0,
};
