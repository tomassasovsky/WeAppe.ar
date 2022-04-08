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
      employers: json['employers'] as List<ObjectId>?,
      employees: json['employees'] as List<ObjectId>?,
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
