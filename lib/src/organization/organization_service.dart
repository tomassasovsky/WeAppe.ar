import 'dart:async';

import 'package:backend/src/database/database.dart';
import 'package:backend/src/organization/organization.dart';
import 'package:mongo_dart/mongo_dart.dart';

class OrganizationService {
  OrganizationService(this.dbService);

  final DatabaseService dbService;

  FutureOr<Organization?> findOrganizationById(dynamic id) async {
    final objectId = (id is ObjectId) ? id : ObjectId.parse(id as String);

    final organization = await dbService.organizationsCollection.findOne(
      where.id(objectId),
    );

    if (organization == null || organization.isEmpty) {
      return null;
    }

    return Organization.fromJson(organization);
  }

  FutureOr<WriteResult> addToDatabase(Organization organization) async {
    return dbService.organizationsCollection.insertOne(
      organization.toJson(),
    );
  }

  FutureOr<Organization?> findOrganizationByNameAndUserId({
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
