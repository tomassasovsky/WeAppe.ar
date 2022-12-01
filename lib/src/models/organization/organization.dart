import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:weappear_backend/database/database.dart';
import 'package:weappear_backend/database/db_model.dart';
import 'package:weappear_backend/src/utils/object_parsers.dart';

part 'organization.g.dart';

@JsonSerializable(explicitToJson: true)
class Organization extends DBModel<Organization> {
  Organization({
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
      super.id;
    } catch (e) {}
  }

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationFromJson(json);

  String name;
  @JsonKey(includeIfNull: false, fromJson: ObjectId.parse)
  ObjectId admin;
  String? homePageUrl;
  String? imageUrl;
  String color;

  @JsonKey(fromJson: objectIdsFromJsonList)
  List<ObjectId>? employers;

  @JsonKey(fromJson: objectIdsFromJsonList)
  List<ObjectId>? employees;

  List<String> get employersAsStrings =>
      employers?.map((e) => e.toHexString()).toList() ?? [];

  List<String> get employeesAsStrings =>
      employees?.map((e) => e.toHexString()).toList() ?? [];

  bool containsUser(String userId) =>
      employersAsStrings.contains(userId) ||
      employeesAsStrings.contains(userId) ||
      (admin.toHexString() == userId);

  bool hasAdminPrivileges(ObjectId userId) =>
      (employers?.contains(userId) ?? false) || (admin == userId);

  @override
  Map<String, dynamic> toJson() => _$OrganizationToJson(this);

  @override
  Organization fromJson(Map<String, dynamic> json) =>
      Organization.fromJson(json);

  static Organization get generic => Organization(
        name: '',
        admin: ObjectId(),
        color: '',
      );
}
