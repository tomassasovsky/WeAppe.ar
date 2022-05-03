import 'package:backend/src/database/database.dart';
import 'package:backend/src/db_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'invite.g.dart';

enum UserType {
  @JsonValue('employer')
  employer,
  @JsonValue('employee')
  employee,
}

@JsonSerializable(explicitToJson: true)
class Invite extends DBModel<Invite> {
  Invite({
    required this.emitter,
    required this.recipient,
    required this.organization,
    required this.refId,
    required this.userType,
    this.message,
  }) : super(DatabaseService().invitesCollection);

  factory Invite.fromJson(Map<String, dynamic> json) => _$InviteFromJson(json);

  ObjectId emitter;
  ObjectId organization;
  String recipient;
  String refId;
  String? message;
  UserType userType;
  Timestamp? timestamp;

  /// expires after 7 days of the invite being created
  bool get isExpired => (DateTime.now().millisecondsSinceEpoch + 604800000) < ((timestamp?.seconds ?? 0) * 1000);

  @override
  Map<String, dynamic> toJson({bool showTimestamp = true}) => _$InviteToJson(this, showTimestamp);

  @override
  Invite fromJson(Map<String, dynamic> json) => Invite.fromJson(json);

  static Invite get generic {
    return Invite(
      emitter: ObjectId(),
      recipient: '',
      organization: ObjectId(),
      refId: '',
      userType: UserType.employee,
    );
  }

  // TODO: add jsonSchema to Invite class
  @override
  Map<String, dynamic> get jsonSchema => <String, dynamic>{};
}
