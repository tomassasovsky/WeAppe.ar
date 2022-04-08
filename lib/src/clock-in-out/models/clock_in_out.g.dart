// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clock_in_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClockInOut _$ClockInOutFromJson(Map<String, dynamic> json) => ClockInOut(
      userId: json['userId'] as ObjectId,
      organizationId: json['organizationId'] as ObjectId,
      clockIn: DateTime.parse(json['clockIn'] as String),
      clockOut: (json['clockOut'] as String?) != null
          ? DateTime.parse(json['clockOut'] as String)
          : null,
    )..id = json['_id'] as ObjectId?;

Map<String, dynamic> _$ClockInOutToJson(ClockInOut instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id?.$oid);
  writeNotNull('userId', instance.userId);
  writeNotNull('organizationId', instance.organizationId);
  writeNotNull('clockIn', instance.clockIn.toIso8601String());
  writeNotNull('clockOut', instance.clockOut?.toIso8601String());
  return val;
}
