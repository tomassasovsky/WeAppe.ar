part of 'join_organization.dart';

class JoinOrganizationMiddleware extends AuthenticationMiddleware {
  const JoinOrganizationMiddleware();

  @override
  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    await super.call(req, res);

    final refId = req.params['refId'] as String?;

    if (refId == null) {
      throw AlfredException(404, {
        'message': 'No refId provided',
      });
    }

    final invite = await services.invites.findByRefId(refId);

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

    final organization = await services.organizations.findOrganizationById(
      invite.organization,
    );

    if (organization == null) {
      throw AlfredException(404, {
        'message': 'No organization found',
      });
    }

    req.store.set('invite', invite);
    req.store.set('organization', organization);
  }
}
