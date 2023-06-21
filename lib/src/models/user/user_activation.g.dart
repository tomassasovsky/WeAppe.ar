// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_activation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserActivation _$UserActivationFromJson(Map<String, dynamic> json) =>
    UserActivation(
      activationCode: json['activationCode'] as String,
      email: json['email'] as String,
      createdAt: const BsonTimestampConverter().fromJson(json['createdAt']),
      verified: json['verified'] as bool? ?? false,
    )..id = objectId(json['_id']);

Map<String, dynamic> _$UserActivationToJson(UserActivation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id?.toJson());
  val['activationCode'] = instance.activationCode;
  val['email'] = instance.email;
  val['createdAt'] = const BsonTimestampConverter().toJson(instance.createdAt);
  val['verified'] = instance.verified;
  return val;
}
