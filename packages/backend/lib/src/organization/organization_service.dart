import 'dart:async';

import 'package:backend/src/database/database.dart';
import 'package:mongo_dart/mongo_dart.dart';

class OrganizationService {
  OrganizationService(this.dbService);

  final DatabaseService dbService;

  FutureOr<Organization?> findOrganizationById(dynamic id) async {
    final objectId = (id is ObjectId) ? id : ObjectId.parse(id as String);

    final organization = await dbService.organizations.findOne(
      where.id(objectId),
    );

    if (organization == null || organization.isEmpty) {
      return null;
    }

    return Organization.fromJson(organization);
  }

  FutureOr<Organization?> findOrganizationByNameAndUserId({
    required String name,
    required String userId,
  }) async {
    final userIdAsObjectId = ObjectId.parse(userId);
    final rawOrganization = await dbService.organizations.findOne(
      where.eq('name', name).and(
            where
                .eq('employers', userIdAsObjectId)
                .or(where.eq('admin', userIdAsObjectId)),
          ),
    );

    if (rawOrganization == null || rawOrganization.isEmpty) {
      return null;
    }

    final organization = Organization.fromJson(rawOrganization);

    return organization;
  }
}
