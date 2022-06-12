part of 'models.dart';

/// {@template organization_model}
/// The model for the organizations.
/// {@endtemplate}
@JsonSerializable(explicitToJson: true)
class Organization extends DBModel<Organization> {
  /// {@macro organization_model}
  Organization({
    required this.name,
    required this.admin,
    this.homePageUrl,
    this.imageUrl,
    this.employers,
    this.employees,
  }) : super(Database().organizations);

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationFromJson(json);

  /// The name of the organization.
  String name;

  /// The admin of the organization.
  ObjectId admin;

  /// The url of the organization's home page.
  String? homePageUrl;

  /// The url of the organization's image.
  String? imageUrl;

  /// The employers of the organization.
  List<ObjectId>? employers;

  /// The employees of the organization.
  List<ObjectId>? employees;

  /// Whether the userId is part of the organization.
  bool containsUser(ObjectId userId) =>
      (employers?.contains(userId) ?? false) ||
      (employees?.contains(userId) ?? false) ||
      (admin == userId);

  /// Whether the userId is an employer or admin of the organization.
  bool hasAdminPrivileges(ObjectId userId) =>
      (employers?.contains(userId) ?? false) || (admin == userId);

  @override
  Map<String, dynamic> toJson() => _$OrganizationToJson(this);

  /// Finds an organization by the [name] and [admin].
  static Future<Organization?> byNameAndAdmin(
    String name,
    ObjectId admin,
  ) async {
    return await Organization.generic.findOne(
      where.eq('name', name).and(
            where.eq('employers', admin).or(where.eq('admin', admin)),
          ),
    );
  }

  /// Finds an organization by the [name] and [user], indiferent to
  /// the latter being either an employee, employer or an admin.
  static Future<Organization?> byNameAndUser(
    String name,
    ObjectId user,
  ) async {
    return await Organization.generic.findOne(
      where.eq('name', name).and(
            where.eq('employers', user).or(
                  where.eq('admin', user).or(
                        where.eq('employees', user),
                      ),
                ),
          ),
    );
  }

  @override
  Organization fromJson(Map<String, dynamic> json) =>
      Organization.fromJson(json);

  /// A generic model for the organizations.
  /// Allows access to the utilities provided by the [DBModel] class.
  static Organization get generic => _$OrganizationGeneric;

  @override
  Map<String, dynamic> get jsonSchema => _$OrganizationJsonSchema;
}
