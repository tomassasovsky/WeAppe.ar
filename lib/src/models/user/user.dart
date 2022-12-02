import 'dart:async';

import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:weappear_backend/database/database.dart';
import 'package:weappear_backend/database/db_model.dart';
import 'package:weappear_backend/src/utils/object_parsers.dart';

part 'user.g.dart';

enum Gender {
  @JsonValue('male')
  male,
  @JsonValue('female')
  female,
  @JsonValue('helicopter')
  helicopter;

  factory Gender.fromString(
    String? value, {
    Gender orElse = Gender.helicopter,
  }) {
    switch (value) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      default:
        return Gender.helicopter;
    }
  }
}

@JsonSerializable(explicitToJson: true)
class User extends DBModel<User> {
  User({
    ObjectId? id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.password,
    this.description,
    this.location,
    this.photo,
    this.organizations,
    this.activationDate,
    this.gender = Gender.helicopter,
    this.lang = 'en_US',
    this.timezone = 'GMT',
  }) {
    try {
      super.collection = DatabaseService().usersCollection;
      super.id = id;
    } catch (e) {}
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  String firstName;
  String lastName;
  String email;
  String? password;
  String? description;
  String? location;
  String? photo;
  String lang;
  String timezone;
  Gender gender;

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

  Map<String, dynamic> get toJsonResponse {
    final response = toJson()..remove('password');
    response['activationDate'] = _activationDateAsDateTime?.toIso8601String();
    return response;
  }

  User copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? description,
    String? location,
    String? photo,
    Gender? gender,
    String? lang,
    String? timezone,
  }) {
    return User(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      description: description ?? this.description,
      location: location ?? this.location,
      photo: photo ?? this.photo,
      gender: gender ?? this.gender,
      activationDate: activationDate,
      lang: lang ?? this.lang,
      timezone: timezone ?? this.timezone,
    );
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
