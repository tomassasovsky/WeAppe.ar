part of 'models.dart';

/// {@template user_activation_model}
/// The model for the User Activations.
/// {@endtemplate}
@JsonSerializable(explicitToJson: true)
class UserActivation extends DBModel<UserActivation> {
  /// {@macro user_activation_model}
  UserActivation({
    required this.activationKey,
    required this.userId,
  }) : super(Database().userActivation);

  factory UserActivation.fromJson(Map<String, dynamic> json) =>
      _$UserActivationFromJson(json);

  /// The activation key of the user.
  String activationKey;

  /// The user id of the user this corresponds to.
  ObjectId userId;

  @override
  UserActivation fromJson(Map<String, dynamic> json) =>
      UserActivation.fromJson(json);

  /// A generic model for the user activation.
  /// Allows access to the utilities provided by the [DBModel] class.
  static UserActivation get generic => _$UserActivationGeneric;

  @override
  Map<String, dynamic> get jsonSchema => _$UserActivationJsonSchema;

  @override
  Map<String, dynamic> toJson() => _$UserActivationToJson(this);
}
