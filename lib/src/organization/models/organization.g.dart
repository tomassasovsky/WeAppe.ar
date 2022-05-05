// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Organization _$OrganizationFromJson(Map<String, dynamic> json) => Organization(
      name: json['name'] as String,
      admin: json['admin'] as ObjectId,
      homePageUrl: json['homePageUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
      employers: (json['employers'] as List?)?.cast<ObjectId>(),
      employees: (json['employees'] as List?)?.cast<ObjectId>(),
    )..id = json['_id'] as ObjectId?;

Map<String, dynamic> _$OrganizationToJson(
  Organization instance,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('admin', instance.admin);
  writeNotNull('homePageUrl', instance.homePageUrl);
  writeNotNull('imageUrl', instance.imageUrl);
  writeNotNull('employers', instance.employers);
  writeNotNull('employees', instance.employees);
  return val;
}

Map<String, dynamic> get _$OrganizationJsonSchema {
  return <String, dynamic>{
    r'$jsonSchema': {
      'bsonType': 'object',
      'properties': {
        'name': {
          'bsonType': 'string',
          'description': 'must be a string and is required',
        },
        'admin': {
          'bsonType': 'objectId',
          'description': 'must be a string and is required',
        },
        'homePageUrl': {
          'bsonType': 'string',
          'description': 'must be a string',
          'pattern': Validators.urlRegExp.pattern,
        },
        'imageUrl': {
          'bsonType': 'objectId',
          'pattern': Validators.urlRegExp.pattern,
          'description': 'must be a string',
        },
        'employers': {
          'bsonType': 'array',
          'description': 'must be an array',
          'uniqueItems': true,
          'items': {
            'bsonType': 'objectId',
            'description': 'must be an objectId',
          },
        },
        'employees': {
          'bsonType': 'array',
          'description': 'must be an array',
          'uniqueItems': true,
            'items': {
            'bsonType': 'objectId',
            'description': 'must be an objectId',
          },
        },
      },
      'required': [
        'name',
        'admin',
      ],
    }
  };
}
