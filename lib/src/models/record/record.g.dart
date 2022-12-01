// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Record _$RecordFromJson(Map<String, dynamic> json) => Record(
      userId: ObjectId.parse(json['userId'] as String),
      organizationId: ObjectId.parse(json['organizationId'] as String),
      clockIn: const BsonTimestampConverter().fromJson(json['clockIn']),
      clockOut: const BsonTimestampNullConverter().fromJson(json['clockOut']),
      durationInMiliseconds: json['durationInMiliseconds'] as int?,
    )..id = objectId(json['_id'] as ObjectId);

Map<String, dynamic> _$RecordToJson(Record instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id?.toJson());
  val['userId'] = instance.userId.toJson();
  val['organizationId'] = instance.organizationId.toJson();
  val['clockIn'] = const BsonTimestampConverter().toJson(instance.clockIn);
  val['clockOut'] =
      const BsonTimestampNullConverter().toJson(instance.clockOut);
  val['durationInMiliseconds'] = instance.durationInMiliseconds;
  return val;
}
