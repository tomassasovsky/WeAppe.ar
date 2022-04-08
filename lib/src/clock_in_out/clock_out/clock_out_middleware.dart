part of 'clock_out.dart';

class ClockOutMiddleware extends AuthenticationMiddleware {
  const ClockOutMiddleware();

  @override
  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    await super.call(req, res);
    final userId = req.store.get<User>('user').id;
    final params = req.params;
    final organizationId = params['id'] as String?;

    if (organizationId == null) {
      res.reasonPhrase = 'organizationIdRequired';
      throw AlfredException(400, {
        'message': 'organizationId is required!',
      });
    }

    final organization = await services.organizations.findOrganizationById(organizationId);

    if (organization == null) {
      res.reasonPhrase = 'organizationNotFound';
      throw AlfredException(404, {
        'message': 'organization not found!',
      });
    }

    final clockInQuery = await services.clockInOuts.findLastClockIn(
      organizationId: organizationId,
      userId: userId,
    );

    if (clockInQuery == null || clockInQuery.clockOut != null) {
      res.reasonPhrase = 'clockInClosed';
      throw AlfredException(404, {
        'message': "you don't have any clock in open!",
      });
    }

    req.store.set('clockInOut', clockInQuery);
  }
}
