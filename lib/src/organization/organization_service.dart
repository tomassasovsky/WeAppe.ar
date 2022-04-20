import 'package:backend/src/database/database.dart';
import 'package:backend/src/organization/models/organization.dart';
import 'package:mongo_dart/mongo_dart.dart';

class OrganizationService {
  OrganizationService(this.dbService);

  final DatabaseService dbService;

  Future<Organization?> findOrganizationById(dynamic id) async {
    final objectId = (id is ObjectId) ? id : ObjectId.parse(id as String);

    final organization = await dbService.organizationsCollection.findOne(
      where.id(objectId),
    );

    if (organization == null || organization.isEmpty) {
      return null;
    }

    return Organization.fromJson(organization);
  }

  Future<WriteResult> addToDatabase(Organization organization) async {
    return dbService.organizationsCollection.insertOne(
      organization.toJson(),
    );
  }

  Future<Organization?> findOrganizationByNameAndUserId({
    required String name,
    required String userId,
  }) async {
    final rawOrganization = await dbService.organizationsCollection.findOne(
      where.eq('name', name),
    );

    if (rawOrganization == null || rawOrganization.isEmpty) {
      return null;
    }

    final organization = Organization.fromJson(rawOrganization);

    final userIdAsObjectId = ObjectId.parse(userId);
    if (organization.hasAdminPrivileges(userIdAsObjectId)) {
      return organization;
    }
    return null;
  }
}
