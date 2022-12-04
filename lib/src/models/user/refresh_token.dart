import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:weappear_backend/database/database.dart';
import 'package:weappear_backend/database/db_model.dart';
import 'package:weappear_backend/src/utils/constants.dart';
import 'package:weappear_backend/src/utils/object_parsers.dart';

part 'refresh_token.g.dart';

/// {@template refresh_token}
/// This class represents a refresh token in the database.
/// {@endtemplate}
@JsonSerializable(explicitToJson: true)
class RefreshToken extends DBModel<RefreshToken> {
  /// {@macro refresh_token}
  RefreshToken({
    ObjectId? id,
    required this.userId,
    required this.refreshToken,
  }) {
    try {
      super.collection = DatabaseService().refreshTokensCollection;
      super.id = id;
    } catch (_) {}
  }

  factory RefreshToken.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenDBFromJson(json);

  /// The id of the user that owns this refresh token.
  @JsonKey(includeIfNull: false, fromJson: ObjectId.parse)
  ObjectId userId;

  /// The refresh token.
  String refreshToken;

  @override
  Map<String, dynamic> toJson() => _$RefreshTokenDBToJson(this);

  /// Whether the refresh token is valid.
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
  RefreshToken fromJson(Map<String, dynamic> json) =>
      RefreshToken.fromJson(json);

  /// Creates a generic refresh token.
  static RefreshToken get generic {
    return RefreshToken(
      userId: ObjectId(),
      refreshToken: '',
    );
  }
}
