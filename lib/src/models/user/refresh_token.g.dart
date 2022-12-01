// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefreshTokenDB _$RefreshTokenDBFromJson(Map<String, dynamic> json) =>
    RefreshTokenDB(
      userId: ObjectId.parse(json['userId'] as String),
      refreshToken: json['refreshToken'] as String,
    )..id = objectId(json['_id']);

Map<String, dynamic> _$RefreshTokenDBToJson(RefreshTokenDB instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id?.toJson());
  val['userId'] = instance.userId.toJson();
  val['refreshToken'] = instance.refreshToken;
  return val;
}
