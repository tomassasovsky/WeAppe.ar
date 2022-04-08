part of 'clock_in.dart';

class ClockInMiddleware extends AuthenticationMiddleware {
  const ClockInMiddleware();

  @override
  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    await super.call(req, res);
    final user = req.store.get<User>('user');
    final params = req.params;
    final dynamic organizationId = params['id'];

    if (user.id == null) {
      res.reasonPhrase = 'userIdRequired';
      throw AlfredException(400, {
        'message': 'user id is required!',
      });
    }

    if (organizationId == null) {
      res.reasonPhrase = 'organizationIdRequired';
      throw AlfredException(400, {
        'message': 'organizationId is required!',
      });
    }

    final organization = await services.organizations
        .findOrganizationById(ObjectId.parse(organizationId as String));

    if (organization == null) {
      res.reasonPhrase = 'organizationNotFound';
      throw AlfredException(404, {
        'message': 'organization not found!',
      });
    }

    if (!organization.containsUser(user.id!)) {
      res.reasonPhrase = 'userNotInOrganization';
      throw AlfredException(404, {
        'message': 'user not in organization!',
      });
    }

    final clockInQuery = await services.clockInOuts.findLastClockIn(
      organizationId: organization.id!,
      userId: user.id!,
    );

    if (clockInQuery != null &&
        !clockInQuery.toJson().containsKey('clockOut')) {
      res.reasonPhrase = 'clockInOpen';
      throw AlfredException(404, {
        'message': 'you have a clock in open!',
      });
    }

    req.store.set('organizationId', organization.id);
  }
}
