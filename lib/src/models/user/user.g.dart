// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: objectId(json['_id']),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      password: json['password'] as String?,
      description: json['description'] as String?,
      location: json['location'] as String?,
      photo: json['photo'] as String?,
      organizations: objectIdsFromJsonList(json['organizations'] as List?),
      activationDate:
          const BsonTimestampNullConverter().fromJson(json['activationDate']),
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']) ??
          Gender.helicopter,
      lang: json['lang'] as String? ?? 'en_US',
      timezone: json['timezone'] as String? ?? 'GMT',
    );

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id?.toJson());
  val['firstName'] = instance.firstName;
  val['lastName'] = instance.lastName;
  val['email'] = instance.email;
  val['password'] = instance.password;
  val['description'] = instance.description;
  val['location'] = instance.location;
  val['photo'] = instance.photo;
  val['lang'] = instance.lang;
  val['timezone'] = instance.timezone;
  val['gender'] = _$GenderEnumMap[instance.gender]!;
  writeNotNull(
      'organizations', instance.organizations?.map((e) => e.toJson()).toList());
  val['activationDate'] =
      const BsonTimestampNullConverter().toJson(instance.activationDate);
  return val;
}

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.helicopter: 'helicopter',
};
