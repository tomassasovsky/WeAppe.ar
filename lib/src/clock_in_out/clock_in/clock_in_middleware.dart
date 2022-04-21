part of 'clock_in.dart';

class ClockInMiddleware extends AuthenticationMiddleware {
  const ClockInMiddleware();

  @override
  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    await super.call(req, res);
    final user = req.store.get<User>('user');

    final organizationId = await InputVariableValidator<String>(req, 'id', source: Source.query).required();
    req.validate();

    final userId = user.id;

    if (userId == null) {
      res.reasonPhrase = 'userIdNotFound';
      throw AlfredException(500, {
        'message': 'user id was not found!',
      });
    }

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
