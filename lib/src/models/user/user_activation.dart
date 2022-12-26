import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:weappear_backend/database/database.dart';
import 'package:weappear_backend/database/db_model.dart';
import 'package:weappear_backend/extensions/datetime.dart';
import 'package:weappear_backend/src/utils/object_parsers.dart';

part 'user_activation.g.dart';

/// {@template user_activation}
/// This class represents an user activation in the database. With this class
/// we validate the user email.
/// {@endtemplate}
@JsonSerializable(explicitToJson: true)
class UserActivation extends DBModel<UserActivation> {
  /// {@macro user_activation}
  UserActivation({
    ObjectId? id,
    required this.activationCode,
    required this.email,
    required this.createdAt,
    this.verified = false,
  }) {
    try {
      super.collection = DatabaseService().userActivationCollection;
      super.id = id;
    } catch (_) {}
  }

  factory UserActivation.fromJson(Map<String, dynamic> json) =>
      _$UserActivationFromJson(json);

  /// The otp activation code.
  String activationCode;

  /// The email of the user.
  String email;

  /// The date when the activation was created.
  @BsonTimestampConverter()
  Timestamp createdAt;

  /// The date when the activation was verified.
  bool verified;

  @override
  UserActivation fromJson(Map<String, dynamic> json) =>
      UserActivation.fromJson(json);

  /// Creates a generic user activation.
  static UserActivation get generic {
    return UserActivation(
      activationCode: '',
      email: '',
      createdAt: Timestamp(),
    );
  }

  /// Creates a map with the response data.
  Map<String, dynamic> get toJsonResponse {
    final json = toJson();
    json['createdAt'] = createdAt.toDateTime().toIso8601String();
    return json;
  }

  @override
  Map<String, dynamic> toJson() => _$UserActivationToJson(this);
}
