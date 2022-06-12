part of 'models.dart';

/// {@template invite_model}
/// The model for the invites.
/// {@endtemplate}
@JsonSerializable(explicitToJson: true)
class Invite extends DBModel<Invite> {
  /// {@macro invite_model}
  Invite({
    required this.emitter,
    required this.recipient,
    required this.organization,
    required this.refId,
    required this.userType,
    this.message,
  }) : super(Database().invites);

  factory Invite.fromJson(Map<String, dynamic> json) => _$InviteFromJson(json);

  /// The user who sent the invite.
  ObjectId emitter;

  /// The organization that the [recipient] is being invited to.
  ObjectId organization;

  /// The email who received the invite.
  String recipient;

  /// The reference id of the invitation.
  /// This is a unique code that the user has to enter to accept the invitation.
  /// When it's accepted, the user will be added to the organization,
  /// and the refId will be deleted.
  String refId;

  /// The message that the [emitter] can send to the [recipient].
  String? message;

  /// The type of the [recipient].
  /// This can be either [UserType.employee] or [UserType.employer].
  UserType userType;

  /// When the invite was created.
  /// This is used to determine if the invite has expired.
  Timestamp? timestamp;

  /// Finds an invite by the [refId].
  Future<Invite?> byRefId(String refId) async {
    return await findOne(where.eq('refId', refId));
  }

  /// expires after 7 days of the invite being created
  bool get isExpired =>
      (DateTime.now().millisecondsSinceEpoch + 604800000) <
      ((timestamp?.seconds ?? 0) * 1000);

  @override
  Map<String, dynamic> toJson({bool showTimestamp = true}) =>
      _$InviteToJson(this, showTimestamp);

  @override
  Invite fromJson(Map<String, dynamic> json) => Invite.fromJson(json);

  /// A generic model for the Invite model.
  /// Allows access to the utilities provided by the [DBModel] class.
  static Invite get generic => _$InviteGeneric;

  @override
  Map<String, dynamic> get jsonSchema => _$InviteJsonSchema;
}

/// A generic model for the Invite model.
enum UserType {
  /// The user is an employee.
  @JsonValue('employer')
  employer,

  /// The user is an employer.
  /// This is the default value.
  @JsonValue('employee')
  employee;

  /// Returns the [UserType] from the [String] value.
  /// If the [String] value is not a valid [UserType],
  /// then [orElse] is returned.
  factory UserType.fromString(
    String? value, {
    UserType orElse = UserType.employee,
  }) {
    switch (value) {
      case 'employer':
        return UserType.employer;
      case 'employee':
        return UserType.employee;
      default:
        return orElse;
    }
  }
}
