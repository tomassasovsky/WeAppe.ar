part of 'send_invite.dart';

class InviteCreateMiddleware extends AuthenticationMiddleware {
  const InviteCreateMiddleware();

  @override
  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    await super.call(req, res);

    final body = await req.bodyAsJsonMap;
    final user = req.store.get<User>('user');
    final organizationName = body['organizationName'] as String?;
    final recipientEmail = body['recipientEmail'] as String?;

    final userId = user.id;

    if (organizationName == null || organizationName.isEmpty) {
      throw AlfredException(403, {
        'message': 'organization name is required',
      });
    }

    if (userId == null) {
      throw AlfredException(500, {
        'message': 'userId not available',
      });
    }

    final organization = await services.organizations.findOrganizationByNameAndUserId(
      userId: userId.$oid,
      name: organizationName,
    );

    if (organization == null) {
      throw AlfredException(404, {
        'message': 'organization not found',
      });
    }

    req.store.set('organization', organization);
    req.store.set('recipientEmail', recipientEmail);
  }
}
