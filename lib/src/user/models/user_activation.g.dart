part of 'user_activation.dart';

UserActivation _$UserActivationFromJson(Map<String, dynamic> json) => UserActivation(
      activationKey: json['activationKey'] as String,
      userId: json['userId'] as ObjectId,
    )..id = json['_id'] as ObjectId?;

Map<String, dynamic> _$UserActivationToJson(UserActivation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('activationKey', instance.activationKey);
  writeNotNull('userId', instance.userId);
  return val;
}

Map<String, dynamic> get _$UserActivationJsonSchema {
  return <String, dynamic>{
    r'$jsonSchema': {
      'bsonType': 'object',
      'properties': {
        'activationKey': {
          'bsonType': 'string',
          'description': 'must be a string and is required',
        },
        'userId': {
          'bsonType': 'objectId',
          'description': 'must be an objectId and is required',
        },
      },
      'required': [
        'activationKey',
        'userId',
      ],
    }
  };
}
