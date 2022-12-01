// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_activation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserActivation _$UserActivationFromJson(Map<String, dynamic> json) =>
    UserActivation(
      activationKey: json['activationKey'] as String,
      userId: ObjectId.parse(json['userId'] as String),
    )..id = objectId(json['_id']);

Map<String, dynamic> _$UserActivationToJson(UserActivation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id?.toJson());
  val['activationKey'] = instance.activationKey;
  val['userId'] = instance.userId.toJson();
  return val;
}
