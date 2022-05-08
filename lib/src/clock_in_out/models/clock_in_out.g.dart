// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clock_in_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClockInOut _$ClockInOutFromJson(Map<String, dynamic> json) => ClockInOut(
      userId: json['userId'] as ObjectId,
      organizationId: json['organizationId'] as ObjectId,
      clockIn: json['clockIn'] as Timestamp,
      clockOut: json['clockOut'] as Timestamp?,
      durationInMiliseconds: json['durationInMiliseconds'] as int?,
    )..id = json['_id'] as ObjectId?;

Map<String, dynamic> _$ClockInOutToJson(ClockInOut instance, bool standardEncoding) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('userId', instance.userId);
  writeNotNull('organizationId', instance.organizationId);
  if (standardEncoding) {
    writeNotNull('clockIn', instance.clockInAsDateTime.toIso8601String());
    writeNotNull('clockOut', instance.clockOutAsDateTime?.toIso8601String());
  } else {
    writeNotNull('clockIn', instance.clockIn);
    writeNotNull('clockOut', instance.clockOut);
  }
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
