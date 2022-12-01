import 'dart:async';

import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:weappear_backend/database/database.dart';
import 'package:weappear_backend/database/db_model.dart';
import 'package:weappear_backend/src/utils/object_parsers.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User extends DBModel<User> {
  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.password,
    this.country,
    this.city,
    this.photo,
    this.organizations,
    this.activationDate,
  }) {
    try {
      super.collection = DatabaseService().usersCollection;
      super.id;
    } catch (e) {}
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  String firstName;
  String lastName;
  String email;
  String? password;
  String? country;
  String? city;
  String? photo;

  @JsonKey(fromJson: objectIdsFromJsonList, includeIfNull: false)
  List<ObjectId>? organizations;

  @BsonTimestampNullConverter()
  Timestamp? activationDate;

  DateTime? get _activationDateAsDateTime => activationDate == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(activationDate!.seconds * 1000);
  bool get isActive => activationDate != null;

  FutureOr<WriteResult> activate() async {
    activationDate = Timestamp();
    return await save();
  }

  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);

  Map<String, dynamic> toJsonResponse() {
    final response = toJson()..remove('password');
    response['activationDate'] = _activationDateAsDateTime?.toIso8601String();
    return response;
  }

  @override
  User fromJson(Map<String, dynamic> json) => User.fromJson(json);

  static User get generic {
    return User(
      firstName: '',
      lastName: '',
      email: '',
    );
  }
}

Timestamp? readJsonValueAsTimestamp(Map<dynamic, dynamic> json, String key) {
  return json[key] as Timestamp;
}
