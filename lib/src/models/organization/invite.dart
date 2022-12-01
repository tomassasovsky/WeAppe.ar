import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:weappear_backend/database/database.dart';
import 'package:weappear_backend/database/db_model.dart';
import 'package:weappear_backend/src/utils/object_parsers.dart';

part 'invite.g.dart';

enum UserType {
  @JsonValue('employer')
  employer,
  @JsonValue('employee')
  employee;

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
        throw ArgumentError('Invalid user type: $value');
    }
  }
}

@JsonSerializable(explicitToJson: true)
class Invite extends DBModel<Invite> {
  Invite({
    required this.emitter,
    required this.organization,
    required this.refId,
    required this.userType,
  }) {
    try {
      super.collection = DatabaseService().invitesCollection;
      super.id;
    } catch (e) {}
  }

  factory Invite.fromJson(Map<String, dynamic> json) => _$InviteFromJson(json);

  @JsonKey(includeIfNull: false, fromJson: ObjectId.parse)
  ObjectId emitter;

  @JsonKey(includeIfNull: false, fromJson: ObjectId.parse)
  ObjectId organization;

  String refId;
  UserType userType;

  @BsonTimestampNullConverter()
  Timestamp? timestamp;

  /// expires after 3 days of the invite being created
  bool get isExpired =>
      (DateTime.now().add(Duration(days: 3)).millisecondsSinceEpoch) <
      ((timestamp?.seconds ?? 0) * 1000);

  @override
  Map<String, dynamic> toJson() => _$InviteToJson(this);

  Map<String, dynamic> get toJsonResponse {
    final response = toJson()..remove('timestamp');
    return response;
  }

  @override
  Invite fromJson(Map<String, dynamic> json) => Invite.fromJson(json);

  static Invite get generic {
    return Invite(
      emitter: ObjectId(),
      organization: ObjectId(),
      refId: '',
      userType: UserType.employee,
    );
  }
}
