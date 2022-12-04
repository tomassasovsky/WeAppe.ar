import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:weappear_backend/database/database.dart';
import 'package:weappear_backend/database/db_model.dart';
import 'package:weappear_backend/src/utils/object_parsers.dart';

part 'invite.g.dart';

/// The types on user for the invitation.
enum UserType {
  /// User is a employer.
  @JsonValue('employer')
  employer,

  /// User is a employee.
  @JsonValue('employee')
  employee;

  /// Creates a [UserType] from a [String].
  factory UserType.fromString(String? value) {
    switch (value) {
      case 'employer':
        return UserType.employer;
      case 'employee':
        return UserType.employee;
      default:
        throw ArgumentError('Invalid user type: $value');
    }
  }
}

/// {@template invite}
/// This class represents an invitation to join an organization.
/// {@endtemplate}
@JsonSerializable(explicitToJson: true)
class Invite extends DBModel<Invite> {
  /// {@macro invite}
  Invite({
    ObjectId? id,
    required this.emitter,
    required this.organization,
    required this.refId,
    required this.userType,
  }) {
    try {
      super.collection = DatabaseService().invitesCollection;
      super.id = id;
    } catch (_) {}
  }

  factory Invite.fromJson(Map<String, dynamic> json) => _$InviteFromJson(json);

  /// The emitter of the invitation.
  @JsonKey(includeIfNull: false, fromJson: ObjectId.parse)
  ObjectId emitter;

  /// The organization to join.
  @JsonKey(includeIfNull: false, fromJson: ObjectId.parse)
  ObjectId organization;

  /// The reference id of the invitation.
  String refId;

  /// The type of user.
  UserType userType;

  /// The [Timestamp] of the creation of the invitation.
  @BsonTimestampNullConverter()
  Timestamp? createdAt;

  /// expires after 3 days of the invite being created
  bool get isExpired =>
      (DateTime.now().add(const Duration(days: 3)).millisecondsSinceEpoch) <
      ((createdAt?.seconds ?? 0) * 1000);

  @override
  Map<String, dynamic> toJson() => _$InviteToJson(this);

  /// Creates a [Map] with the data of the [Invite].
  Map<String, dynamic> get toJsonResponse {
    final response = toJson()..remove('timestamp');
    return response;
  }

  @override
  Invite fromJson(Map<String, dynamic> json) => Invite.fromJson(json);

  /// Creates a generic [Invite].
  static Invite get generic {
    return Invite(
      emitter: ObjectId(),
      organization: ObjectId(),
      refId: '',
      userType: UserType.employee,
    );
  }
}
