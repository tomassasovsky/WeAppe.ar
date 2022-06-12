// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      country: json['country'] as String?,
      city: json['city'] as String?,
      imageUrl: json['photo'] as String?,
      organizations: (json['organizations'] as List?)?.cast<ObjectId>(),
      activationDate: json['activationDate'] as Timestamp?,
    )..id = json['_id'] as ObjectId?;

Map<String, dynamic> _$UserToJson(User instance,
    {required bool showPassword, required bool standardEncoding}) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('firstName', instance.firstName);
  writeNotNull('lastName', instance.lastName);
  writeNotNull('email', instance.email);
  if (showPassword) writeNotNull('password', instance.password);
  writeNotNull('country', instance.country);
  writeNotNull('city', instance.city);
  writeNotNull('photo', instance.imageUrl);
  writeNotNull('organizations', instance.organizations);
  if (standardEncoding) {
    writeNotNull('activationDate',
        instance._activationDateAsDateTime?.toIso8601String());
  } else {
    writeNotNull('activationDate', instance.activationDate);
  }
  return val;
}

Map<String, dynamic> get _$UserJsonSchema {
  return <String, dynamic>{
    r'$jsonSchema': {
      'bsonType': 'object',
      'properties': {
        'email': {
          'bsonType': 'string',
          'pattern': Validators.emailRegExp.pattern,
          'description': 'must be a string and is required',
        },
        'firstName': {
          'bsonType': 'string',
          'description': 'must be a string and is required',
        },
        'lastName': {
          'bsonType': 'string',
          'description': 'must be a string and is required',
        },
        'password': {
          'bsonType': 'string',
          'description': 'must be a string and is required',
        },
        'country': {
          'bsonType': 'string',
          'description': 'must be a string',
        },
        'city': {
          'bsonType': 'string',
          'description': 'must be a string',
        },
        'photo': {
          'bsonType': 'string',
          'description': 'must be a string',
        },
        'organizations': {
          'bsonType': 'array',
          'description': 'must be an array',
          'uniqueItems': true,
          'items': {
            'bsonType': 'objectId',
            'description': 'must be an objectId',
          },
        },
        'activationDate': {
          'bsonType': 'timestamp',
          'description': 'must be a timestamp',
        },
      },
      'required': [
        'email',
        'password',
        'firstName',
        'lastName',
      ],
    }
  };
}

User get _$UserGeneric => User(
      firstName: '',
      lastName: '',
      email: '',
      password: '',
    );
