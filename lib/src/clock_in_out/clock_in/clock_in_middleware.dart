part of 'clock_in.dart';

class ClockInMiddleware extends Middleware {
  late final String organizationId;
  late final ObjectId userId;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) async {
    organizationId = await InputVariableValidator<String>(req, 'id', source: Source.query).required();
    userId = req.store.get<ObjectId>('userId');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    final organization = await Services().organizations.findOrganizationById(
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

    final clockInQuery = await Services().clockInOuts.findLastClockIn(
          organizationId: organizationId,
          userId: userId,
        );

    if (clockInQuery != null && clockInQuery.clockOut != null) {
      res.reasonPhrase = 'clockInOpen';
      throw AlfredException(409, {
        'message': 'you have a clock in open!',
      });
    }

    req.store.set('organizationId', organizationId);
  }
}
