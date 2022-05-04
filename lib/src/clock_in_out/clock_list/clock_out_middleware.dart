part of 'clock_out.dart';

class ClockListMiddleware extends AuthenticationMiddleware {
  const ClockListMiddleware();

  @override
  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    await super.call(req, res);
    final userId = req.store.get<User>('user').id;
    final params = req.params;
    final organizationId = params['id'] as String?;

    if (userId == null) {
      res.reasonPhrase = 'userIdNotFound';
      throw AlfredException(500, {
        'message': 'user id was not found!',
      });
    }

    if (organizationId == null) {
      res.reasonPhrase = 'organizationIdRequired';
      throw AlfredException(400, {
        'message': 'organizationId is required!',
      });
    }

    final organization = await services.organizations.findOrganizationById(
      organizationId,
    );

    if (organization == null) {
      res.reasonPhrase = 'organizationNotFound';
      throw AlfredException(404, {
        'message': 'organization not found!',
      });
    }

    if (!organization.containsUser(userId)) {
      res.reasonPhrase = 'userNotInOrganization';
      throw AlfredException(404, {
        'message': 'user not in organization!',
      });
    }

    final clockInOuts = await services.clockInOuts.getClockList(
      organizationId: ObjectId.parse(organizationId),
      userId: userId,
    );

    if (clockInOuts == null || clockInOuts.isEmpty) {
      res.reasonPhrase = 'clockInOutsNotFound';
      throw AlfredException(404, {
        'message': 'clock in outs not found!',
      });
    }

    req.store.set('clockInOuts', clockInOuts);
  }
}
