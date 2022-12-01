// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invite _$InviteFromJson(Map<String, dynamic> json) => Invite(
      emitter: ObjectId.parse(json['emitter'] as String),
      organization: ObjectId.parse(json['organization'] as String),
      refId: json['refId'] as String,
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
    )
      ..id = objectId(json['_id'])
      ..timestamp =
          const BsonTimestampNullConverter().fromJson(json['timestamp']);

Map<String, dynamic> _$InviteToJson(Invite instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id?.toJson());
  val['emitter'] = instance.emitter.toJson();
  val['organization'] = instance.organization.toJson();
  val['refId'] = instance.refId;
  val['userType'] = _$UserTypeEnumMap[instance.userType]!;
  val['timestamp'] =
      const BsonTimestampNullConverter().toJson(instance.timestamp);
  return val;
}

const _$UserTypeEnumMap = {
  UserType.employer: 'employer',
  UserType.employee: 'employee',
};
