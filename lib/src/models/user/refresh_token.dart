import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:weappear_backend/src/utils/constants.dart';
import 'package:weappear_backend/database/database.dart';
import 'package:weappear_backend/database/db_model.dart';
import 'package:weappear_backend/src/utils/object_parsers.dart';

part 'refresh_token.g.dart';

@JsonSerializable(explicitToJson: true)
class RefreshTokenDB extends DBModel<RefreshTokenDB> {
  RefreshTokenDB({
    required this.userId,
    required this.refreshToken,
  }) : super(DatabaseService().refreshTokensCollection);

  factory RefreshTokenDB.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenDBFromJson(json);

  @JsonKey(includeIfNull: false, fromJson: ObjectId.parse)
  ObjectId userId;
  String refreshToken;

  @override
  Map<String, dynamic> toJson() => _$RefreshTokenDBToJson(this);

  bool get isValid {
    try {
      JWT.verify(
        refreshToken,
        SecretKey(Constants.jwtAccessSignature),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  RefreshTokenDB fromJson(Map<String, dynamic> json) =>
      RefreshTokenDB.fromJson(json);

  static RefreshTokenDB get generic {
    return RefreshTokenDB(
      userId: ObjectId(),
      refreshToken: '',
    );
  }
}
