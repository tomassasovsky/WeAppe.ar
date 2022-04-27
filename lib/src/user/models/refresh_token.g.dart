// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefreshTokenDB _$RefreshTokenDBFromJson(Map<String, dynamic> json) => RefreshTokenDB(
      refreshToken: json['refreshToken'] as String,
      userId: json['userId'] as ObjectId,
    )..id = json['_id'] as ObjectId?;

Map<String, dynamic> _$RefreshTokenDBToJson(RefreshTokenDB instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('refreshToken', instance.refreshToken);
  writeNotNull('userId', instance.userId);
  return val;
}
