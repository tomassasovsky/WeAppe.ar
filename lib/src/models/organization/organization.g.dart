// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Organization _$OrganizationFromJson(Map<String, dynamic> json) => Organization(
      name: json['name'] as String,
      admin: ObjectId.parse(json['admin'] as String),
      color: json['color'] as String,
      homePageUrl: json['homePageUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
      employers: objectIdsFromJsonList(json['employers'] as List?),
      employees: objectIdsFromJsonList(json['employees'] as List?),
    )..id = objectId(json['_id']);

Map<String, dynamic> _$OrganizationToJson(Organization instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id?.toJson());
  val['name'] = instance.name;
  val['admin'] = instance.admin.toJson();
  val['homePageUrl'] = instance.homePageUrl;
  val['imageUrl'] = instance.imageUrl;
  val['color'] = instance.color;
  val['employers'] = instance.employers?.map((e) => e.toJson()).toList();
  val['employees'] = instance.employees?.map((e) => e.toJson()).toList();
  return val;
}
