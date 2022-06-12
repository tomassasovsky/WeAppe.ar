// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invite _$InviteFromJson(Map<String, dynamic> json) => Invite(
      emitter: json['emitter'] as ObjectId,
      recipient: json['recipient'] as String,
      organization: json['organization'] as ObjectId,
      refId: json['refId'] as String,
      message: json['message'] as String?,
      userType: UserType.values
          .firstWhere((e) => e.name == json['userType'] as String),
    )
      ..id = (json['_id'] as ObjectId?)
      ..timestamp = json['timestamp'] as Timestamp?;

Map<String, dynamic> _$InviteToJson(Invite instance, bool showTimestamp) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('emitter', instance.emitter);
  writeNotNull('recipient', instance.recipient);
  writeNotNull('organization', instance.organization);
  writeNotNull('refId', instance.refId);
  writeNotNull('message', instance.message);
  writeNotNull('userType', instance.userType.name);
  if (showTimestamp) writeNotNull('timestamp', instance.timestamp);
  return val;
}

Map<String, dynamic> get _$InviteJsonSchema {
  return <String, dynamic>{
    r'$jsonSchema': {
      'bsonType': 'object',
      'properties': {
        'emitter': {
          'bsonType': 'objectId',
          'description': 'must be a string and is required',
        },
        'recipient': {
          'bsonType': 'string',
          'description': 'must be a string and is required',
        },
        'organization': {
          'bsonType': 'objectId',
          'description': 'must be a string and is required',
        },
        'refId': {
          'bsonType': 'string',
          'description': 'must be a string and is required',
        },
        'message': {
          'bsonType': 'string',
          'description': 'must be a string and is required',
        },
        'userType': {
          'enum': UserType.values.map((e) => e.name).toList(),
          'description': 'must be a string and is required',
        },
      },
      'required': [
        'emitter',
        'recipient',
        'organization',
        'refId',
        'userType',
      ],
    }
  };
}

Invite get _$InviteGeneric => Invite(
      emitter: ObjectId(),
      recipient: '',
      organization: ObjectId(),
      refId: '',
      userType: UserType.employee,
    );
