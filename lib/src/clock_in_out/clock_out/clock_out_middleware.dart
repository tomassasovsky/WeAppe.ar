part of 'clock_out.dart';

class ClockOutMiddleware extends Middleware {
  late final String organizationId;
  late final ObjectId userId;

  @override
  FutureOr<dynamic> defineVars(HttpRequest req, HttpResponse res) async {
    organizationId = await InputVariableValidator<String>(req, 'id', source: Source.query).required();
    userId = req.store.get<ObjectId>('userId');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
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

    final clockInId = clockInQuery?.id;

    if (clockInQuery == null || clockInQuery.clockOut != null || clockInId == null) {
      res.reasonPhrase = 'clockInClosed';
      throw AlfredException(404, {
        'message': "you don't have any clock in open!",
      });
    }

    req.store.set('clockInOutId', clockInId);
  }
}
