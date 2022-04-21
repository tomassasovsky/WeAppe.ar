part of 'join_organization.dart';

class JoinOrganizationMiddleware extends AuthenticationMiddleware {
  const JoinOrganizationMiddleware();

  @override
  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    await super.call(req, res);

    final refId = await InputVariableValidator<String>(req, 'refId', source: Source.query).required();

    req.validate();

    final userId = req.store.get<ObjectId>('userId');

    final invite = await Services().invites.findByRefId(refId);

    if (invite == null) {
      throw AlfredException(404, {
        'message': 'No invite found',
      });
    }

    if (invite.isExpired) {
      throw AlfredException(404, {
        'message': 'invite is expired',
      });
    }

    final organization = await Services().organizations.findOrganizationById(
          invite.organization,
        );

    if (organization == null) {
      throw AlfredException(404, {
        'message': 'No organization found',
      });
    }

    if ((organization.employees ?? []).contains(userId) && invite.userType == UserType.employee) {
      throw AlfredException(400, {
        'message': 'User is already a member of this organization as an employee',
      });
    }

    if ((organization.employers ?? []).contains(userId) && invite.userType == UserType.employer) {
      throw AlfredException(400, {
        'message': 'User is already a member of this organization as an employer',
      });
    }

    if (organization.admin == userId) {
      throw AlfredException(400, {
        'message': "User is already this organization's admin",
      });
    }

    req.store.set('invite', invite);
    req.store.set('organization', organization);
  }
}
