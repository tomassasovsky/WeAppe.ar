part of 'clock_in.dart';

class ClockInMiddleware extends AuthenticationMiddleware {
  const ClockInMiddleware();

  @override
  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    await super.call(req, res);
    final user = req.store.get<User>('user');
    final body = await req.bodyAsJsonMap;
    final dynamic organizationId = body['organizationId'];

    if (organizationId == null) {
      res.reasonPhrase = 'organizationIdRequired';
      throw AlfredException(400, {
        'message': 'organizationId is required!',
      });
    }

    final organization = await services.organizations
        .findOrganizationById(id: organizationId as String);

    if (organization == null) {
      res.reasonPhrase = 'organizationNotFound';
      throw AlfredException(404, {
        'message': 'organization not found!',
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
