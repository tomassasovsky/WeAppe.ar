part of 'models.dart';

/// {@template refresh_token_model}
/// The model for the Refresh Tokens.
/// {@endtemplate}
@JsonSerializable(explicitToJson: true)
class RefreshTokenDB extends DBModel<RefreshTokenDB> {
  /// {@macro refresh_token_model}
  RefreshTokenDB({
    required this.userId,
    required this.refreshToken,
  }) : super(Database().refreshTokens);

  /// Parses the refresh token from a JSON Map.
  factory RefreshTokenDB.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenDBFromJson(json);

  /// The user id of the user this corresponds to.
  ObjectId userId;

  /// The refresh token itself.
  String refreshToken;

  /// Finds a refresh token by the [refreshToken].
  Future<RefreshTokenDB?> byToken(String refreshToken) async {
    return await generic.findOne(
      where.eq('refreshToken', refreshToken),
    );
  }

  /// Finds a refresh token by the [userId].
  bool validate(String signature) {
    try {
      JWT.verify(refreshToken, SecretKey(signature));
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Map<String, dynamic> toJson() => _$RefreshTokenDBToJson(this);

  @override
  RefreshTokenDB fromJson(Map<String, dynamic> json) =>
      RefreshTokenDB.fromJson(json);

  /// A generic model for the refresh token.
  /// Allows access to the utilities provided by the [DBModel] class.
  static RefreshTokenDB get generic => _$RefreshTokenDBGeneric;

  @override
  Map<String, dynamic> get jsonSchema => _$RefreshTokenJsonSchema;
}
