part of 'clock_out.dart';

class ClockOutMiddleware extends Middleware<ClockOutMiddleware> {
  late final String organizationId;
  late final ObjectId userId;

  @override
  FutureOr<dynamic> defineVars(HttpRequest req, HttpResponse res) async {
    organizationId = await InputVariableValidator<String>(
      req,
      'id',
      source: Source.query,
      regExp: Validators.mongoIdRegExp,
      regExpErrorMessage: 'invalid organization id',
    ).required();
    userId = req.store.get<ObjectId>('userId');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    final organization = await Organization.generic.byId(this.organizationId);
    final organizationId = organization?.id;

    if (organization == null || organizationId == null) {
      res.reasonPhrase = 'organizationNotFound';
      throw AlfredException(404, {
        'message': 'organization not found!',
      });
    }

    final loggedTime = await LoggedTime.generic.last(
      organizationId: organizationId,
      userId: userId,
    );

    if (loggedTime == null || loggedTime.id == null || loggedTime.end != null) {
      res.reasonPhrase = 'clockInClosed';
      throw AlfredException(404, {
        'message': "you don't have any clock in open!",
      });
    }

    req.store.set('loggedTime', loggedTime);
  }

  @override
  ClockOutMiddleware get newInstance => ClockOutMiddleware();
}
