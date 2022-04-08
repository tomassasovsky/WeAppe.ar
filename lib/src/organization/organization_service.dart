import 'package:backend/src/database/database.dart';
import 'package:backend/src/organization/models/organization.dart';
import 'package:backend/src/services/services.dart';
import 'package:mongo_dart/mongo_dart.dart';

class OrganizationService {
  OrganizationService(this.dbService);

  final DatabaseService dbService;

  Future<Organization?> findOrganizationById({
    required String id,
  }) async {
    final organization =
        await dbService.usersCollection.findOne(where.id(ObjectId.parse(id)));

    if (organization == null || organization.isEmpty) {
      return null;
    }

    return Organization.fromJson(organization);
  }

  Future<WriteResult> addToDatabase(Organization organization) async {
    return dbService.organizationCollection.insertOne(
      organization.toJson(),
    );
  }

  Future<Organization?> findOrganizationByNameAndUserId({
    required String name,
    required String userId,
  }) async {
    final organization = await dbService.organizationCollection
        .findOne(where.eq('name', name).eq('admin', userId));

    if (organization == null || organization.isEmpty) {
      return null;
    }

    return Organization.fromJson(organization);
  }
}
