import 'package:backend/src/database/database.dart';
import 'package:backend/src/db_model.dart';
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

  @override
  Map<String, dynamic> toJson({bool showPassword = true}) => _$UserToJson(this, showPassword);

  @override
  User fromJson(Map<String, dynamic> json) => User.fromJson(json);
}
