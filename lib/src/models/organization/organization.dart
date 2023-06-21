import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:weappear_backend/database/database.dart';
import 'package:weappear_backend/database/db_model.dart';
import 'package:weappear_backend/src/utils/object_parsers.dart';

part 'organization.g.dart';

/// {@template organization}
/// This class represents an organization model.
/// {@endtemplate}
@JsonSerializable(explicitToJson: true)
class Organization extends DBModel<Organization> {
  /// {@macro organization}
  Organization({
    ObjectId? id,
    required this.name,
    required this.admin,
    required this.color,
    this.homePageUrl,
    this.imageUrl,
    this.employers,
    this.employees,
  }) {
    try {
      super.collection = DatabaseService().organizationsCollection;
      super.id = id;
    } catch (_) {}
  }

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationFromJson(json);

  /// The name of the organization.
  String name;

  /// The admin of the organization.
  @JsonKey(includeIfNull: false, fromJson: ObjectId.parse)
  ObjectId admin;

  /// The home page url of the organization.
  String? homePageUrl;

  /// The image url of the organization.
  String? imageUrl;

  /// The color of the organization.
  String color;

  /// The list of employers of the organization.
  @JsonKey(fromJson: objectIdsFromJsonList)
  List<ObjectId>? employers;

  /// The list of employees of the organization.
  @JsonKey(fromJson: objectIdsFromJsonList)
  List<ObjectId>? employees;

  /// Returns a [List] of [String] with the ids of the employers.
  List<String> get employersAsStrings =>
      employers?.map((e) => e.toHexString()).toList() ?? [];

  /// Returns a [List] of [String] with the ids of the employees.
  List<String> get employeesAsStrings =>
      employees?.map((e) => e.toHexString()).toList() ?? [];

  /// Whether this user id is in the organization.
  bool containsUser(String userId) =>
      employersAsStrings.contains(userId) ||
      employeesAsStrings.contains(userId) ||
      (admin.toHexString() == userId);

  /// Wheter the user has admin privileges.
  bool hasAdminPrivileges(ObjectId userId) =>
      (employers?.contains(userId) ?? false) || (admin == userId);

  @override
  Map<String, dynamic> toJson() => _$OrganizationToJson(this);

  @override
  Organization fromJson(Map<String, dynamic> json) =>
      Organization.fromJson(json);

  /// Creates a generic [Organization].
  static Organization get generic => Organization(
        name: '',
        admin: ObjectId(),
        color: '',
      );
}
