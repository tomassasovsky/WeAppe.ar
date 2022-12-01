import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:weappear_backend/database/database.dart';
import 'package:weappear_backend/database/db_model.dart';
import 'package:weappear_backend/src/utils/object_parsers.dart';

part 'user_activation.g.dart';

@JsonSerializable(explicitToJson: true)
class UserActivation extends DBModel<UserActivation> {
  UserActivation({
    required this.activationKey,
    required this.userId,
  }) : super(DatabaseService().userActivationCollection);

  factory UserActivation.fromJson(Map<String, dynamic> json) =>
      _$UserActivationFromJson(json);

  String activationKey;
  @JsonKey(includeIfNull: false, fromJson: ObjectId.parse)
  ObjectId userId;

  @override
  UserActivation fromJson(Map<String, dynamic> json) =>
      UserActivation.fromJson(json);

  static UserActivation get generic {
    return UserActivation(
      activationKey: '',
      userId: ObjectId(),
    );
  }

  @override
  Map<String, dynamic> toJson() => _$UserActivationToJson(this);
}
