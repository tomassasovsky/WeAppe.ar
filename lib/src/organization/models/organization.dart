import 'package:backend/src/database/database.dart';
import 'package:backend/src/db_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'organization.g.dart';

@JsonSerializable(explicitToJson: true)
class Organization extends DBModel<Organization> {
  Organization({
    required this.name,
    required this.admin,
    this.homePageUrl,
    this.imageUrl,
    this.employers,
    this.employees,
  }) : super(database.organizationsCollection);

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationFromJson(json);

  String name;
  ObjectId admin;
  String? homePageUrl;
  String? imageUrl;
  List<ObjectId>? employers;
  List<ObjectId>? employees;

  bool containsUser(ObjectId userId) =>
      (employers?.contains(userId) ?? false) ||
      (employees?.contains(userId) ?? false) ||
      (admin == userId);

  @override
  Map<String, dynamic> toJson() => _$OrganizationToJson(this);

  @override
  Organization fromJson(Map<String, dynamic> json) =>
      Organization.fromJson(json);
}
