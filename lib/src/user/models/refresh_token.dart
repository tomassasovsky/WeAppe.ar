import 'package:backend/backend.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'refresh_token.g.dart';

@JsonSerializable(explicitToJson: true)
class RefreshTokenDB extends DBModel<RefreshTokenDB> {
  RefreshTokenDB({
    required this.userId,
    required this.refreshToken,
  }) : super(DatabaseService().refreshTokensCollection);

  factory RefreshTokenDB.fromJson(Map<String, dynamic> json) => _$RefreshTokenDBFromJson(json);

  ObjectId userId;
  String refreshToken;

  @override
  Map<String, dynamic> toJson() => _$RefreshTokenDBToJson(this);

  bool get isValid {
    try {
      JWT.verify(
        refreshToken,
        Services().jwtRefreshSigner,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  RefreshTokenDB fromJson(Map<String, dynamic> json) => RefreshTokenDB.fromJson(json);

  static RefreshTokenDB get generic {
    return RefreshTokenDB(
      userId: ObjectId(),
      refreshToken: '',
    );
  }

  @override
  Map<String, dynamic> get jsonSchema => _$RefreshTokenJsonSchema;
}
