part of 'clock_out.dart';

class ClockOutMiddleware extends AuthenticationMiddleware {
  const ClockOutMiddleware();

  @override
  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    await super.call(req, res);
    final userId = req.store.get<User>('user').id;

    final organizationId = await InputVariableValidator<String>(req, 'id', source: Source.query).required();
    req.validate();

    final organization = await Services().organizations.findOrganizationById(organizationId);

    if (organization == null) {
      res.reasonPhrase = 'organizationNotFound';
      throw AlfredException(404, {
        'message': 'organization not found!',
      });
    }

    final clockInQuery = await Services().clockInOuts.findLastClockIn(
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
