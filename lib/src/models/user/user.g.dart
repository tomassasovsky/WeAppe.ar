// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      password: json['password'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      photo: json['photo'] as String?,
      organizations: objectIdsFromJsonList(json['organizations'] as List?),
      activationDate:
          const BsonTimestampNullConverter().fromJson(json['activationDate']),
    )..id = objectId(json['_id'] as ObjectId);

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
  val['country'] = instance.country;
  val['city'] = instance.city;
  val['photo'] = instance.photo;
  writeNotNull(
      'organizations', instance.organizations?.map((e) => e.toJson()).toList());
  val['activationDate'] =
      const BsonTimestampNullConverter().toJson(instance.activationDate);
  return val;
}
