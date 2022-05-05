// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clock_in_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClockInOut _$ClockInOutFromJson(Map<String, dynamic> json) => ClockInOut(
      userId: json['userId'] as ObjectId,
      organizationId: json['organizationId'] as ObjectId,
      clockIn: DateTime.parse(json['clockIn'] as String),
      clockOut: (json['clockOut'] as String?) != null ? DateTime.parse(json['clockOut'] as String) : null,
      durationInMiliseconds: json['durationInMiliseconds'] as int?,
    )..id = json['_id'] as ObjectId?;

Map<String, dynamic> _$ClockInOutToJson(ClockInOut instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('userId', instance.userId);
  writeNotNull('organizationId', instance.organizationId);
  writeNotNull('clockIn', instance.clockIn.toIso8601String());
  writeNotNull('clockOut', instance.clockOut?.toIso8601String());
  writeNotNull('durationInMiliseconds', instance.durationInMiliseconds);
  return val;
}

Map<String, dynamic> get _$ClockInOutJsonSchema {
  return <String, dynamic>{
    r'$jsonSchema': {
      'bsonType': 'object',
      'properties': {
        'userId': {
          'bsonType': 'objectId',
          'description': 'must be an objectId and is required',
        },
        'organizationId': {
          'bsonType': 'objectId',
          'description': 'must be an objectId and is required',
        },
        'clockIn': {
          'bsonType': 'timestamp',
          'description': 'must be a timestamp and is required',
        },
        'clockOut': {
          'bsonType': 'timestamp',
          'description': 'must be a timestamp',
        },
        'durationInMiliseconds': {
          'bsonType': 'int',
          'description': 'must be an int and is required',
        },
      },
      'required': [
        'userId',
        'organizationId',
        'clockIn',
      ],
    }
  };
}
