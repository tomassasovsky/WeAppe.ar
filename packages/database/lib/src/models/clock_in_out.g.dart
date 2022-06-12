// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoggedTime _$LoggedTimeFromJson(Map<String, dynamic> json) => LoggedTime()
  ..id = (json['_id'] as ObjectId?)
  .._userId = (json['userId'] as ObjectId)
  .._organizationId = (json['organizationId'] as ObjectId)
  .._start = (json['clockIn'] as Timestamp)
  ..end = (json['clockOut'] as Timestamp?)
  ..durationInMiliseconds = (json['durationInMiliseconds'] as int?);

Map<String, dynamic> _$LoggedTimeToJson(
    LoggedTime instance, bool standardEncoding) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('userId', instance._userId);
  writeNotNull('organizationId', instance._organizationId);
  if (standardEncoding) {
    writeNotNull('clockIn', instance.clockInAsDateTime.toIso8601String());
    writeNotNull('clockOut', instance.clockOutAsDateTime?.toIso8601String());
  } else {
    writeNotNull('clockIn', instance._start);
    writeNotNull('clockOut', instance.end);
  }
  writeNotNull('durationInMiliseconds', instance.durationInMiliseconds);
  return val;
}

Map<String, dynamic> get _$LoggedTimeJsonSchema {
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

LoggedTime get _$LoggedTimeGeneric => LoggedTime();
