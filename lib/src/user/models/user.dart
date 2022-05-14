import 'dart:async';

import 'package:backend/backend.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User extends DBModel<User> {
  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.country,
    this.city,
    this.photo,
    this.organizations,
    this.activationDate,
  }) : super(DatabaseService().usersCollection);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  String firstName;
  String lastName;
  String email;
  String password;
  String? country;
  String? city;
  String? photo;
  List<ObjectId>? organizations;
  Timestamp? activationDate;

  DateTime? get _activationDateAsDateTime => activationDate == null ? null : DateTime.fromMillisecondsSinceEpoch(activationDate!.seconds * 1000);
  bool get isActive => activationDate != null;

  FutureOr<WriteResult> activate() async {
    activationDate = Timestamp();
    return await save();
  }

  @override
  Map<String, dynamic> toJson({
    bool showPassword = true,
    bool standardEncoding = false,
  }) =>
      _$UserToJson(
        this,
        showPassword: showPassword,
        standardEncoding: standardEncoding,
      );

  @override
  User fromJson(Map<String, dynamic> json) => User.fromJson(json);

  static User get generic {
    return User(
      firstName: '',
      lastName: '',
      email: '',
      password: '',
    );
  }

  @override
  Map<String, dynamic> get jsonSchema => _$UserJsonSchema;
}
